package linear.algebra.matrix.core

public class NumberHelper {
	public static val abs = new UnaryDispatch(
		[ a | Math.abs(a) ],
		[ a | a.abs() ],
		[ a | Math.abs(a) ],
		[ a | a.abs() ]
	)

	public static val negative = new UnaryDispatch(
		[ a | -a ],
		[ a | a.negative ],
		[ a | -a ],
		[ a | a.negative ]
	)

	public static val square = new UnaryDispatch(
		[ a | a * a ],
		[ a | Rational.multiply(a, a) ],
		[ a | a * a ],
		[ a | Complex.multiply(a, a) ]
	)

	public static def Number exp(Number base, int exp) {
		new UnaryDispatch(
			[ a | (a**exp) as int ],
			[ a | Rational.exp(a, exp) ],
			[ a | a**exp ],
			[ a | Complex.exp(a, exp) ]
		).of(base)
	}

	public static val sum = new BinaryDispatch(
		[ a, b | a + b ],
		[ a, b | Rational.add(a, b) ],
		[ a, b | a + b ],
		[ a, b | Complex.add(a, b) ]
	)

	public static val difference = new BinaryDispatch(
		[ a, b | a - b ],
		[ a, b | Rational.subtract(a, b) ],
		[ a, b | a - b ],
		[ a, b | Complex.subtract(a, b) ]
	)

	public static val product = new BinaryDispatch(
		[ a, b | a * b ],
		[ a, b | Rational.multiply(a, b) ],
		[ a, b | a * b ],
		[ a, b | Complex.multiply(a, b) ]
	)

	public static val quotient = new BinaryDispatch(
		[ a, b | new Rational(a, b) ],
		[ a, b | Rational.divide(a, b) ],
		[ a, b | a / b ],
		[ a, b | Complex.divide(a, b) ]
	)

	public static val equality = new BinaryDispatch(
		[ a, b | a == b ],
		[ a, b | a == b ],
		[ a, b | a == b ],
		[ a, b | a == b ]
	)

	@Data public static class UnaryDispatch {
		(Integer)=>Integer intCallback
		(Rational)=>Rational rationalCallback
		(Double)=>Double realCallback
		(Complex)=>Number complexCallback

		def dispatch Number of(Integer i) {
			intCallback.apply(i)
		}

		def dispatch Number of(Rational r) {
			rationalCallback.apply(r)
		}

		def dispatch Number of(Double r) {
			realCallback.apply(r)
		}

		def dispatch Number of(Complex c) {
			complexCallback.apply(c)
		}
	}

	@Data public static class BinaryDispatch<Result> {
		(Integer, Integer)=>Result intCallback
		(Rational, Rational)=>Result rationalCallback
		(Double, Double)=>Result realCallback
		(Complex, Complex)=>Result complexCallback

		def dispatch Result of(Integer a, Integer b) {
			intCallback.apply(a, b)
		}

		def dispatch Result of(Rational a, Rational b) {
			rationalCallback.apply(a, b)
		}

		def dispatch Result of(Rational a, Integer b) {
			of(a, Rational.valueOf(b))
		}

		def dispatch Result of(Integer a, Rational b) {
			of(Rational.valueOf(a), b)
		}

		def dispatch Result of(Double a, Double b) {
			realCallback.apply(a, b)
		}

		def dispatch Result of(Double a, Integer b) {
			of(a, b.doubleValue())
		}

		def dispatch Result of(Integer a, Double b) {
			of(a.doubleValue(), b)
		}

		def dispatch Result of(Double a, Rational b) {
			of(a, b.doubleValue())
		}

		def dispatch Result of(Rational a, Double b) {
			of(a.doubleValue(), b)
		}

		def dispatch Result of(Complex a, Complex b) {
			complexCallback.apply(a, b)
		}

		def dispatch Result of(Complex a, Integer b) {
			of(a, Complex.valueOf(b))
		}

		def dispatch Result of(Integer a, Complex b) {
			of(Complex.valueOf(a), b)
		}

		def dispatch Result of(Complex a, Rational b) {
			of(a, Complex.valueOf(b))
		}

		def dispatch Result of(Rational a, Complex b) {
			of(Complex.valueOf(a), b)
		}

		def dispatch Result of(Complex a, Double b) {
			of(a, Complex.valueOf(b))
		}

		def dispatch Result of(Double a, Complex b) {
			of(Complex.valueOf(a), b)
		}
	}
}