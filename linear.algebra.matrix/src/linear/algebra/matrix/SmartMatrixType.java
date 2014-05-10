package linear.algebra.matrix;

import linear.algebra.matrix.matrix.MatrixType;
import linear.algebra.matrix.matrix.impl.MatrixTypeImpl;

public class SmartMatrixType extends MatrixTypeImpl implements MatrixType {
	private final int matrixHeight;
	private final int matrixWidth;

	public SmartMatrixType(int height, int width) {
		super();
		this.height = Integer.toString(matrixHeight = height);
		this.width = Integer.toString(matrixWidth = width);
	}

	public static SmartMatrixType fromMatrixType(MatrixType other) {
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
