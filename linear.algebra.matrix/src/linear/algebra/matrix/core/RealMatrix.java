package linear.algebra.matrix.core;

public class RealMatrix extends Matrix<Double> {
	private final Double[][] entries;

	public RealMatrix(int height, int width) {
		super(height, width);
		entries = new Double[height][width];
	}

	@Override
	protected Double[][] getEntries() {
		return entries;
	}
}
