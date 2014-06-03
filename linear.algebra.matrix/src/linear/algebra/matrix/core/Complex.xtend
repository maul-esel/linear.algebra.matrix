package linear.algebra.matrix.core

import static linear.algebra.matrix.core.NumberHelper.*

class Complex extends Number {
	val Number re
	val Number im

	new(Number real, Number imaginary) {
		if (!(real instanceof Integer || real instanceof Rational || real instanceof Double))
			throw new UnsupportedOperationException()
		if (!(imaginary instanceof Integer || imaginary instanceof Rational || imaginary instanceof Double))
			throw new UnsupportedOperationException()
		re = real
		im = imaginary
	}

	def Complex negative() {
		new Complex(negative.of(re), negative.of(im))
	}

	def Complex inverse() {
		// 1/(a+bi) = (a-bi)/((a+bi)(a-bi)) = a/(a²+b²) - bi/(a²+b²)
		val squares = sum.of(square.of(re), square.of(im))
		new Complex(quotient.of(re, squares), negative.of(quotient.of(im, squares)))
	}

	def Complex conjugate() {
		new Complex(re, negative.of(im))
	}

	def Double abs() {
		Math.sqrt(sum.of(square.of(re), square.of(im)).doubleValue())
	}

	def static Complex valueOf(Object n) {
		if (n instanceof Complex)
			n
		else if (n instanceof Number)
			new Complex(n, 0)
		else throw new IllegalStateException("Cannot create Complex from " + n)
	}

	// equals() etc.
	override equals(Object other) {
		if (other instanceof Complex)
			re.equals(other.re) && im.equals(other.im)
		else
			false
	}

	override hashCode() {
		re.hashCode() + im.hashCode()
	}

	override toString() {
		re + " + " + im + "i"
	}

	// abstract Number methods
	override doubleValue() {
		re.doubleValue()
	}

	override floatValue() {
		re.floatValue()
	}

	override intValue() {
		re.intValue()
	}

	override longValue() {
		re.longValue()
	}

	// static arithmetic methods
	public static val ZERO = new Complex(0, 0)
	public static val ONE = new Complex(1, 0)
	public static val IMAGINARY_UNIT = new Complex(0, 1)

	def static Complex add(Complex a, Complex b) {
		new Complex(sum.of(a.re, b.re), sum.of(a.im, b.im))
	}

	def static Complex subtract(Complex a, Complex b) {
		add(a, b.negative)
	}

	def static Complex multiply(Complex a, Complex b) {
		// (a + bi)*(c + di) = (ac -bd) + (ad+bc)i
		val re = difference.of(product.of(a.re, b.re), product.of(a.im, b.im))
		val im = sum.of(product.of(a.re, b.im), product.of(a.im, b.re))
		new Complex(re, im)
	}

	def static Complex divide(Complex a, Complex b) {
		multiply(a, b.inverse)
	}

	def static Complex exp(Complex b, int e) {
		var base = if (e < 0) b.inverse else b
		var exp = if (e < 0) -e else e

		var result = ONE;
		for (i : 1..exp)
			result = multiply(result, base);

		result
	}
}