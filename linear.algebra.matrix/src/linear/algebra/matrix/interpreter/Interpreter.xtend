package linear.algebra.matrix.interpreter

import linear.algebra.matrix.matrix.MatrixSyntaxElement
import linear.algebra.matrix.matrix.Expression

import linear.algebra.matrix.semantics.GenericRegister

interface Interpreter {
	def void interpret() throws MatrixException, InterpreterException
	def void interpret(MatrixSyntaxElement syntax) throws MatrixException, InterpreterException
	def Object evaluate(Expression expr) throws MatrixException, InterpreterException
	def Object evaluate(Expression expr, VariableRegister vars, GenericRegister gen) throws MatrixException, InterpreterException

	def StackTrace getStackTrace()
}