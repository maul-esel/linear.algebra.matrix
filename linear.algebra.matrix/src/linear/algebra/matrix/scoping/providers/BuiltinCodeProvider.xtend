package linear.algebra.matrix.scoping.providers

import linear.algebra.matrix.core.Matrix

class BuiltinCodeProvider extends AbstractDeclarativeProvider {
	def void proc_printBoolean(boolean b) {
		System.out.println(b)
	}

	def void proc_printNumber(Number n) {
		System.out.println(n)
	}

	def void proc_printMatrix(Matrix<?> m) {
		System.out.println(m)
	}
}