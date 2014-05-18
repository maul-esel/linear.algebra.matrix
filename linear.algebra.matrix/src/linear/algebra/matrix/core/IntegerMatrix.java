package linear.algebra.matrix.core;

public class IntegerMatrix extends Matrix<Integer> {
	private final Integer[][] entries;

	public IntegerMatrix(int height, int width) {
		super(height, width);
		entries = new Integer[height][width];
	}

	@Override
	protected Integer[][] getEntries() {
		return entries;
	}
}