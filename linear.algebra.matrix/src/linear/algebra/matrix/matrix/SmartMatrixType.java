package linear.algebra.matrix.matrix;

import linear.algebra.matrix.matrix.impl.MatrixTypeImpl;

public class SmartMatrixType extends MatrixTypeImpl {
	public SmartMatrixType(String height, String width, MathematicalType entryType) {
		super();
		setHeight(height);
		setWidth(width);

		if (entryType == null)
			setEntryType(MatrixFactory.eINSTANCE.createIntegerType());
		else
			setEntryType(entryType);
	}

	// typing helper methods
	public static SmartMatrixType copy(MatrixType other) {
		return new SmartMatrixType(other.getHeight(), other.getWidth(), other.getEntryType());
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

	public boolean dimensionsEqual(MatrixType other) {
		return height.contentEquals(other.getHeight()) && width.contentEquals(other.getWidth());
	}

	// make immutable
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
	public void setEntryType(MathematicalType entryType) {
		if (this.entryType != null)
			throw new IllegalStateException("Entry type already set");
		super.setEntryType(entryType);
	}

	// overridden Object methods
	@Override
	public String toString() {
		return entryType.toString() + "(" + height + "°" + width + ")";
	}
}
