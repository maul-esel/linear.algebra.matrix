package linear.algebra.matrix.interpreter

import it.xsemantics.runtime.RuleEnvironment

import java.util.Stack
import java.util.List

import linear.algebra.matrix.core.Tuple

import linear.algebra.matrix.semantics.GenericRegister

import linear.algebra.matrix.scoping.providers.CodeProvider
import linear.algebra.matrix.scoping.providers.InterpretationMethod

import linear.algebra.matrix.matrix.*

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.util.Diagnostician
import org.eclipse.emf.common.util.Diagnostic
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.EcoreUtil2

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

public class InterpreterImpl implements Interpreter {
	@Inject
	private ExpressionInterpretation exprInterpreter

	@Inject
	private CodeProvider provider

	private Resource resource

	private StackTrace trace = new StackTrace()
	private Stack<VariableRegister> variables = new Stack<VariableRegister>()
	private Stack<GenericRegister> generics = new Stack<GenericRegister>()

	@Inject
	new(@Assisted Resource res, Diagnostician doc) {
		EcoreUtil2.resolveLazyCrossReferences(res, CancelIndicator.NullImpl)
		if (doc.validate(res.contents.get(0)).severity == Diagnostic.ERROR)
			throw new IllegalStateException("Cannot interpret resource: it has errors")

		resource = res;
		variables.push(new VariableRegister())
		generics.push(new GenericRegister());
	}

	override void interpret() {
		val code = resource.contents.get(0) as Code;

		for (line : code.lines)
			interpret(line)
	}

	override getStackTrace() {
		trace
	}

	def dispatch void interpret(VarDeclaration decl) {
		trace.enter(decl)
		if (decl.value != null) {
			var value = evaluate(decl.value)
			if (decl instanceof TypedVarDeclaration)
				value = implicitCoerce(value, resolveType(decl.type))
			currentScope.add(decl.name, value, decl.const)
		} else
			currentScope.add(decl.name)
		trace.leave()
	}

	def dispatch void interpret(CombinedTupleVarDeclaration combined) {
		trace.enter(combined)
		val tuple = evaluate(combined.tuple) as Tuple
		for (i : 0..<combined.decls.size) {
			var decl = combined.decls.get(i)
			trace.enter(decl)
			if (decl instanceof TupleVarDeclaration) {
				var value = tuple.get(i)
				if (decl.type != null) // explicit type specified ~> coerce accordingly
					value = implicitCoerce(value, decl.type)
				currentScope.add(decl.name, value, decl.const)
			}
			trace.leave()
		}
		trace.leave()
	}

	def dispatch void interpret(ReturnStatement ret) {
		trace.enter(ret)

		var Object value = null
		if (ret.value != null)
			value = evaluate(ret.value)

		trace.leave()
		throw new ReturnEncounteredException(value)
	}

	def dispatch void interpret(FailureStatement error) {
		trace.enter(error)
		var String message = ""
		if (error.msg != null)
			message = interpretMessage(error.msg)
		throw new MatrixException(message, trace)
	}

	private def String interpretMessage(FailureMessage msg) {
		msg.fragments.map [ f |
			switch(f) {
				LiteralMessageFragment : f.content.replace("\\'", "'")
				ExpressionMessageFragment : evaluate(f.expr).toString()
			}
		].filterNull.filter [ !isEmpty ].join
	}

	def dispatch void interpret(ProcCall call) {
		val providerProc = provider.getProcsFor(resource).findFirst [
			interpretationMethod == InterpretationMethod.Provider
			&& EcoreUtil2.equals(proc, call.proc.ref)
		]

		var List<Object> evaluatedParams
		if (providerProc != null)
			evaluatedParams = call.params.map [ evaluate ]

		trace.enter(call)
		trace.enter(call.proc.ref)
		if (providerProc != null)
			provider.interpretProc(resource, providerProc, evaluatedParams)
		else
			executeWithParams(call.proc.ref.params.params, call.params, call.proc.ref.body, null)
		trace.leave()
		trace.leave()
	}

	def dispatch void interpret(ProcDeclaration proc) {} // doesn't do anything

	def dispatch void interpret(FromToLoop loop) {
		trace.enter(loop)
		currentScope.set(loop.getVar.ref.name, evaluate(loop.init)) // initialize counter
		try {
			while ((evaluate(loop.getVar) as Integer) <= (evaluate(loop.end) as Integer)) {
				interpret(loop.body)
				currentScope.set(loop.getVar.ref.name, (evaluate(loop.getVar) as Integer) + 1)
			}
		} catch (ReturnEncounteredException e) {
			trace.leave()
			throw e
		}
		trace.leave()
	}

	def dispatch void interpret(WhileLoop loop) {
		trace.enter(loop)
		try {
			while (evaluate(loop.cond) as Boolean)
				interpret(loop.body)
		} catch (ReturnEncounteredException e) {
			trace.leave()
			throw e
		}
		trace.leave()
	}

	def dispatch void interpret(Block block) {
		trace.enter(block)
		variables.push(new VariableRegister(currentScope)) // introduce block scope
		try {
			for (line : block.lines)
				interpret(line)
		} catch (ReturnEncounteredException e) { // not in finally, as this must only be done for returns, not real exceptions
			trace.leave()
			throw e
		} finally { // make sure block scope is removed even when return occurs
			variables.pop()
		}
		trace.leave()
	}

	def dispatch void interpret(IfElse ifElse) {
		trace.enter(ifElse)
		val boolean cond = evaluate(ifElse.cond) as Boolean;
		try {
			if (cond)
				interpret(ifElse.ifTrue)
			else if (ifElse.getElse != null)
				interpret(ifElse.getElse)
		} catch (ReturnEncounteredException e) {
			trace.leave()
			throw e
		}
		trace.leave()
	}

	def dispatch void interpret(FuncDeclaration decl) {} // doesn't do anything

	def dispatch void interpret(Expression expr) { // namely Assignment and FunctionCall instances
		evaluate(expr)
	}

	def Object implicitCoerce(Object value, Type type) {
		val res = exprInterpreter.implicitCoerce(value, type)
		if (res.ruleFailedException != null)
			throw res.ruleFailedException
		res.value
	}

	def dispatch Object evaluate(Expression expr) {
		trace.enter(expr)
		val result = exprInterpreter.interpret(environment(), expr)
		if (result.failed) {
			switch (cause : originalRuleFailure(result.ruleFailedException).cause) {
				MatrixException:
					throw cause
				InterpreterException:
					throw new InterpreterException("Could not evaluate expression", cause, trace)
				default:
					throw new InterpreterException("Could not evaluate expression", result.ruleFailedException, trace)
			}
		}
		trace.leave()
		result.value
	}

	def dispatch Object evaluate(FunctionCall call) { // special handling for func calls!
		val providerFunc = provider.getFunctionsFor(resource).findFirst [
			interpretationMethod == InterpretationMethod.Provider
			&& EcoreUtil2.equals(func, call.func.ref)
		]

		var List<Object> evaluatedParams
		if (providerFunc != null)
			evaluatedParams = call.params.map [ evaluate ]

		trace.enter(call)
		trace.enter(call.func.ref)
		val value = if (providerFunc != null)
			provider.interpretFunction(resource, providerFunc, evaluatedParams)
		else
			executeWithParams(call.func.ref.params.params, call.params, call.func.ref.body, call.func.ref.returnType)
		trace.leave()
		trace.leave()

		value
	}

	override Object evaluate(Expression expr, VariableRegister vars, GenericRegister gen) {
		variables.push(vars)
		generics.push(gen)
		val result = evaluate(expr)

		variables.pop()
		generics.pop()
		result
	}

	def private VariableRegister currentScope() {
		return variables.peek()
	}

	def private Object executeWithParams(List<TypedVarDeclaration> declared,
		List<Expression> supplied, Block exec, Type retType) {
		val execScope = new VariableRegister()
		for (i : 0..<supplied.size)
			execScope.add(declared.get(i).name, evaluate(supplied.get(i))) // set the params
		variables.push(execScope) // add exec scope

		val computed = new GenericRegister()
		exprInterpreter.checkParamTypes(computed, declared, supplied) // call only to compute generics

		val generic = new GenericRegister()
		// replace callers own generics with value:
		for (number : computed.numbers)
			generic.putNumber(number, genericVariableOrValue(computed.getNumber(number)) as String)
		for (typeName : computed.types)
			generic.putType(typeName, genericVariableOrValue(computed.getType(typeName)) as MathematicalType)
		generics.push(generic)

		var Object retVal = null;
		try { interpret(exec) }
		catch (ReturnEncounteredException e) { // get the return value
			retVal = implicitCoerce(e.value, resolveType(retType))
		}

		variables.pop() // remove exec scope
		generics.pop() // remove generic sope
		retVal
	}

	def private genericVariableOrValue(Object value) {
		if (value instanceof String && exprInterpreter.isGeneric(value as String))
			generics.peek().getNumber(value as String)
		else if (value instanceof GenericType)
			generics.peek().getType(value)
		else
			value
	}

	def private Type resolveType(Type type) {
		exprInterpreter.makeTypeExact(type, generics.peek())
	}

	def private originalRuleFailure(it.xsemantics.runtime.RuleFailedException e) {
		var current = e
		while (current.previous != null)
			current = current.previous
		current
	}

	def private environment() {
		val env = new RuleEnvironment()
		env.add("variables", currentScope)
		env.add("generics", generics.peek())
		env.add("interpreter", this)
		env
	}
}

@Data class ReturnEncounteredException extends Exception {
	Object value
}