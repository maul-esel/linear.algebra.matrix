package linear.algebra.matrix.util

class Pair<T1, T2> extends Tuple {
	public val T1 one
	public val T2 two

	new(T1 one, T2 two) {
		super(one, two)
		this.one = one
		this.two = two
	}
}