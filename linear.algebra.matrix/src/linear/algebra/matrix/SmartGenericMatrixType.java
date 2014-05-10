package linear.algebra.matrix;

import linear.algebra.matrix.matrix.impl.GenericMatrixTypeImpl;

public class SmartGenericMatrixType extends GenericMatrixTypeImpl {
	public SmartGenericMatrixType(String height, String width) {
		setHeightVar(height);
		setWidthVar(width);
	}
}
