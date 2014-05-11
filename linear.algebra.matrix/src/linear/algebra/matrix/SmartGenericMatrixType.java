package linear.algebra.matrix;

import linear.algebra.matrix.matrix.impl.GenericMatrixTypeImpl;

public class SmartGenericMatrixType extends GenericMatrixTypeImpl {
	public SmartGenericMatrixType(String height, String width) {
		setHeight(height);
		setWidth(width);
	}
}
