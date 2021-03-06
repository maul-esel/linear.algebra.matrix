package linear.algebra.matrix.core

class Rational extends Number implements Comparable<Rational> {
	val int numerator
	val int denominator

	new(int numerator) {
		this(numerator, 1)
	}

	new(int numerator, int denominator) {
		if (denominator == 0)
			throw new ArithmeticException("Division by zero")

		// make canonical
		val gcd = gcd(numerator, denominator)
		this.numerator = numerator / gcd
		this.denominator = denominator / gcd
	}

	def static private int gcd(int a, int b) {
		if (b == 0) a
		else gcd(b, a % b)
	}

	def negative() {
		new Rational(-numerator, denominator)
	}

	def inverse() {
		new Rational(denominator, numerator)
	}

	def abs() {
		new Rational(Math.abs(numerator), Math.abs(denominator))
	}

	def static Rational valueOf(Object o) {
		if (o instanceof Rational)
			o
		else if (o instanceof Integer)
			new Rational(o)
		else throw new IllegalStateException("Cannot create Rational from " + o)
	}

	// equals() etc.
	override equals(Object other) {
		if (other instanceof Rational)
			numerator * other.denominator == other.numerator * denominator
		else
			false
	}

	override hashCode() {
		numerator / denominator
	}

	override toString() {
		numerator + "/" + denominator
	}

	// IComparable<Fraction>
	override compareTo(Rational other) {
		numerator * other.denominator - other.numerator * denominator
	}

	// abstract Number methods
	override doubleValue() {
		(numerator as double) / (denominator as double)
	}

	override floatValue() {
		(numerator as float) / (denominator as float)
	}

	override intValue() {
		numerator / denominator
	}

	override longValue() {
		(numerator as long) / (denominator as long)
	}

	// static arithmetic methods
	public static val ZERO = new Rational(0, 1)
	public static val ONE = new Rational(1, 1)

	def static Rational add(Rational a, Rational b) {
		new Rational(a.numerator * b.denominator + b.numerator * a.denominator, a.denominator * b.denominator)
	}

	def static Rational subtract(Rational a, Rational b) {
		add(a, b.negative)
	}

	def static Rational multiply(Rational a, Rational b) {
		new Rational(a.numerator * b.numerator, a.denominator * b.denominator)
	}

	def static Rational divide(Rational a, Rational b) {
		multiply(a, b.inverse)
	}

	def static Rational exp(Rational base, int exp) {
		new Rational((base.numerator ** exp) as int, (base.denominator ** exp) as int)
	}

	public static val APPROX_MAX_DENOMINATOR = 100000

	def static approximate(double real) {
		approximate(real, APPROX_MAX_DENOMINATOR)
	}

	// http://www.johndcook.com/blog/2010/10/20/best-rational-approximation/
	def static approximate(double real, int max_denominator) {
		var a = 0
		var b = 1
		var c = 1
		var d = 1

		while (b <= max_denominator && d <= max_denominator) {
			val mediant = (a+c as double) / (b+d as double)
			if (real == mediant)
				return if (b + d <= max_denominator)
					new Rational(a + c, b+ d)
				else if (d > b)
					new Rational(c, d)
				else
					new Rational(a, b)
			else if (real > mediant) {
				a = a + c
				b = b + d
			} else {
				c = a + c
				d = b + d
			}
		}

		if (b > max_denominator)
			new Rational(c, d)
		else
			new Rational(a, b)
	}
}