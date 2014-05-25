package linear.algebra.matrix.core

import static linear.algebra.matrix.core.NumberHelper.*

class Complex extends Number {
	val Number re
	val Number im

	new(Integer real, Integer imaginary) {
		this(real as Number, imaginary as Number)
	}

	new(Rational real, Rational imaginary) {
		this(real as Number, imaginary as Number)
	}

	new(Integer real, Rational imaginary) {
		this(real as Number, imaginary as Number)
	}

	new(Rational real, Integer imaginary) {
		this(real as Number, imaginary as Number)
	}

	private new(Number real, Number imaginary) {
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

	// TODO: abs(), once real numbers are introduced

	def static Complex valueOf(Integer i) {
		new Complex(i, 0)
	}

	def static Complex valueOf(Rational r) {
		new Complex(r, 0)
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
}