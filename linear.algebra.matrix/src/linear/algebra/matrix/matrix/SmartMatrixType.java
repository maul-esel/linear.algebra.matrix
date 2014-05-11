package linear.algebra.matrix.matrix;

import linear.algebra.matrix.matrix.impl.MatrixTypeImpl;

public class SmartMatrixType extends MatrixTypeImpl {
	public SmartMatrixType(String height, String width) {
		super();
		setHeight(height);
		setWidth(width);
	}

	public boolean isExact() {
		try {
			Integer.parseInt(height);
			Integer.parseInt(width);
		} catch (NumberFormatException e) {
			return false;
		}
		return true;
	}

	public boolean isGeneric() {
		try {
			Integer.parseInt(height);
			Integer.parseInt(width);
		} catch (NumberFormatException e) {
			return true;
		}
		return false;
	}

	@Override
	public void setHeight(String height) {
		if (this.height != HEIGHT_EDEFAULT)
			throw new IllegalStateException("Height already set");
		super.setHeight(height);
	}

	@Override
	public void setWidth(String width) {
		if (this.width != WIDTH_EDEFAULT)
			throw new IllegalStateException("Width already set");
		super.setWidth(width);
	}

	@Override
	public boolean equals(Object other) {
		if (!(other instanceof MatrixType))
			return false;

		MatrixType otherType = (MatrixType)other;
		return height.contentEquals(otherType.getHeight()) && width.contentEquals(otherType.getWidth());
	}

	@Override
	public int hashCode() {
		return height.hashCode() + width.hashCode();
	}

	@Override
	public String toString() {
		return "(" + height + "°" + width + ")";
	}

	public static SmartMatrixType copy(MatrixType other) {
		return new SmartMatrixType(other.getHeight(), other.getWidth());
	}

	/* TODO:
	 * support entry type
	 */
}
