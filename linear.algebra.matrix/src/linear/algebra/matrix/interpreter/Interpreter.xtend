package linear.algebra.matrix.interpreter

import linear.algebra.matrix.matrix.Expression

interface Interpreter {
	def void interpret()
	def Object evaluate(Expression expr)
	def Object evaluate(Expression expr, VariableRegister vars, VariableRegister gen)
}