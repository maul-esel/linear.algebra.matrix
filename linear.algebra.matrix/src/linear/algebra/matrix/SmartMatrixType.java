package linear.algebra.matrix;

import linear.algebra.matrix.matrix.ExactMatrixType;
import linear.algebra.matrix.matrix.impl.ExactMatrixTypeImpl;

public class SmartMatrixType extends ExactMatrixTypeImpl {
	private final int matrixHeight;
	private final int matrixWidth;

	public SmartMatrixType(int height, int width) {
		super();
		this.height = Integer.toString(matrixHeight = height);
		this.width = Integer.toString(matrixWidth = width);
	}

	public static SmartMatrixType fromMatrixType(ExactMatrixType other) {
		String height = other.getHeight(), width = other.getWidth();
		if (height == null || width == null)
			throw new IllegalArgumentException();
		return new SmartMatrixType(Integer.parseInt(height), Integer.parseInt(width));
	}

	public int getMatrixHeight() {
		return matrixHeight;
	}

	public int getMatrixWidth() {
		return matrixWidth;
	}

	/* TODO:
	 * support entry type
	 * implement equals() etc.
	 */
}
