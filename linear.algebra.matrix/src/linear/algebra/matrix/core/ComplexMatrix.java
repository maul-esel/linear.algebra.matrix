package linear.algebra.matrix.core;

public class ComplexMatrix extends Matrix<Complex> {
	private final Complex[][] entries;

	public ComplexMatrix(int height, int width) {
		super(height, width);
		entries = new Complex[height][width];
	}

	@Override
	protected Complex[][] getEntries() {
		return entries;
	}
}
