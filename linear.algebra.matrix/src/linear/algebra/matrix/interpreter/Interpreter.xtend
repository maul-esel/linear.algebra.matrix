package linear.algebra.matrix.interpreter

import it.xsemantics.runtime.RuleEnvironment;

import java.util.Stack;

import linear.algebra.matrix.MatrixStandaloneSetup
import linear.algebra.matrix.typing.XSemanticMatrix
import linear.algebra.matrix.util.VariableRegister
import linear.algebra.matrix.matrix.*

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl

import java.util.List
import com.google.inject.Injector

public class Interpreter {
	private static val Injector injector = new MatrixStandaloneSetup().createInjectorAndDoEMFRegistration();

	def static Interpreter fromFile(String file) {
		val rs = new ResourceSetImpl()
		val resource = rs.getResource(URI.createURI(file), true)
		return new Interpreter(resource)
	}

	private val semantics = injector.getInstance(XSemanticMatrix);

	private Resource resource;

	private Stack<VariableRegister> variables = new Stack<VariableRegister>()
	private Stack<VariableRegister> generics = new Stack<VariableRegister>()

	new(Resource res) {
		resource = res;
		variables.push(new VariableRegister())
		generics.push(new VariableRegister());
	}

	def void interpret() {
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

	def dispatch Object evaluate(Expression expr) {
		val env = new RuleEnvironment()
		env.add("variables", currentScope)
		env.add("generics", generics.peek())

		val result = semantics.interpret(env, expr)
		if (result.failed)
			throw result.ruleFailedException
		result.value
	}

	def dispatch Object evaluate(FunctionCall call) { // special handling for func calls!
		executeWithParams(call.func.ref.params.params, call.params, call.func.ref.body)
	}

	def private VariableRegister currentScope() {
		return variables.peek()
	}

	def private Object executeWithParams(List<ParameterDeclaration> declared,
		List<Expression> supplied, Block exec) {
		variables.push(new VariableRegister()) // add exec scope
		for (i : 0..<supplied.size)
			currentScope.add(declared.get(i).name, supplied.get(i)) // set the params

		val computed = new VariableRegister()
		semantics.checkParamTypes(computed, declared, supplied) // call only to compute generics
		val generic = new VariableRegister()
		for (variable : computed.variables) {
			val value = computed.get(variable);
			generic.add(variable,
				if (value instanceof String && semantics.isGeneric(value as String)) generics.peek().get(value as String) else value,
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