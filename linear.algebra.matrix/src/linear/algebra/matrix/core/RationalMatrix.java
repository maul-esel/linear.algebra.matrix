package linear.algebra.matrix.core;

public class RationalMatrix extends Matrix<Rational> {
	private final Rational[][] entries;

	public RationalMatrix(int height, int width) {
		super(height, width);
		entries = new Rational[height][width];
	}

	@Override
	protected Rational[][] getEntries() {
		return entries;
	}
}