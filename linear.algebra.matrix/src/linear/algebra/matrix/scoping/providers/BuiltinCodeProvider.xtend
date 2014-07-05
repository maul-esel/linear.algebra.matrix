package linear.algebra.matrix.scoping.providers

import linear.algebra.matrix.core.Complex
import linear.algebra.matrix.core.Matrix

@Namespace("core")
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

	def double func_re(Complex z) {
		z.realPart.doubleValue
	}

	def double func_im(Complex z) {
		z.imaginaryPart.doubleValue
	}
}