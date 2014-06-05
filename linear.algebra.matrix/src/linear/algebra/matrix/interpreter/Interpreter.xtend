package linear.algebra.matrix.interpreter

import linear.algebra.matrix.matrix.MatrixSyntaxElement
import linear.algebra.matrix.matrix.Expression

interface Interpreter {
	def void interpret()
	def void interpret(MatrixSyntaxElement syntax)
	def Object evaluate(Expression expr)
	def Object evaluate(Expression expr, VariableRegister vars, VariableRegister gen)
}