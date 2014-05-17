package linear.algebra.matrix.interpreter

import it.xsemantics.runtime.RuleEnvironment;

import java.util.Stack;
import java.util.List

import linear.algebra.matrix.matrix.*

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.util.EcoreUtil

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

public class InterpreterImpl implements Interpreter {
	@Inject
	private ExpressionInterpretation exprInterpreter

	private Resource resource

	private Stack<VariableRegister> variables = new Stack<VariableRegister>()
	private Stack<VariableRegister> generics = new Stack<VariableRegister>()

	@Inject
	new(@Assisted Resource res) {
		resource = res;
		EcoreUtil.resolveAll(resource)
		variables.push(new VariableRegister())
		generics.push(new VariableRegister());
	}

	override void interpret() {
		val code = resource.contents.get(0) as Code;

		for (line : code.lines) {
			interpret(line)
		}
		for (variable : currentScope.variables)
			System.out.println(variable + " = " + currentScope.get(variable))
	}

	def dispatch void interpret(VarDeclaration decl) {
		if (decl.value != null)
			currentScope.add(decl.name, evaluate(decl.value), decl.const)
		else
			currentScope.add(decl.name)
	}

	def dispatch void interpret(ReturnStatement ret) {
		if (ret.value != null)
			throw new ReturnEncounteredException(evaluate(ret.value))
		throw new ReturnEncounteredException(null)
	}

	def dispatch void interpret(ProcCall call) {
		executeWithParams(call.proc.ref.params.params, call.params, call.proc.ref.body)
	}

	def dispatch void interpret(ProcDeclaration proc) {} // doesn't do anything

	def dispatch void interpret(FromToLoop loop) {
		currentScope.set(loop.getVar.ref.name, evaluate(loop.init)) // initialize counter
		while ((evaluate(loop.getVar) as Integer) <= (evaluate(loop.end) as Integer)) {
			interpret(loop.body)
			currentScope.set(loop.getVar.ref.name, (evaluate(loop.getVar) as Integer) + 1)
		}
	}

	def dispatch void interpret(WhileLoop loop) {
		while (evaluate(loop.cond) as Boolean)
			interpret(loop.body);
	}

	def dispatch void interpret(Block block) {
		variables.push(new VariableRegister(currentScope)) // introduce block scope
		try {
			for (line : block.lines)
				interpret(line)
		}
		finally { // make sure block scope is removed even when return occurs
			variables.pop()
		}
	}

	def dispatch void interpret(IfElse ifElse) {
		val boolean cond = evaluate(ifElse.cond) as Boolean;
		if (cond)
			interpret(ifElse.ifTrue)
		else if (ifElse.getElse != null)
			interpret(ifElse.getElse)
	}

	def dispatch void interpret(FuncDeclaration decl) {} // doesn't do anything

	def dispatch void interpret(Expression expr) { // namely Assignment and FunctionCall instances
		evaluate(expr)
	}

	def dispatch Object evaluate(Expression expr) {
		val env = new RuleEnvironment()
		env.add("variables", currentScope)
		env.add("generics", generics.peek())
		env.add("interpreter", this)

		val result = exprInterpreter.interpret(env, expr)
		if (result.failed)
			throw result.ruleFailedException
		result.value
	}

	def dispatch Object evaluate(FunctionCall call) { // special handling for func calls!
		executeWithParams(call.func.ref.params.params, call.params, call.func.ref.body)
	}

	override Object evaluate(Expression expr, VariableRegister vars, VariableRegister gen) {
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

	def private Object executeWithParams(List<VarDeclaration> declared,
		List<Expression> supplied, Block exec) {
		val execScope = new VariableRegister()
		for (i : 0..<supplied.size)
			execScope.add(declared.get(i).name, evaluate(supplied.get(i))) // set the params
		variables.push(execScope) // add exec scope

		val computed = new VariableRegister()
		exprInterpreter.checkParamTypes(computed, declared, supplied) // call only to compute generics
		val generic = new VariableRegister()
		for (variable : computed.variables) {
			val value = computed.get(variable);
			generic.add(variable,
				if (value instanceof String && exprInterpreter.isGeneric(value as String)) generics.peek().get(value as String) else value,
				true) // replaces callers own generics with value
		}
		generics.push(generic)

		var Object retVal = null;
		try { interpret(exec) }
		catch (ReturnEncounteredException e) { retVal = e.value } // get the return value

		variables.pop() // remove exec scope
		generics.pop() // remove generic sope
		retVal
	}
}

@Data class ReturnEncounteredException extends Exception {
	Object value
}