package linear.algebra.matrix.matrix

@Deprecated
static class MatrixTypeUtil {
	def static boolean isExact(MatrixType type) {
		try {
			Integer.parseInt(type.height)
			Integer.parseInt(type.width)
		} catch (NumberFormatException e) {
			return false
		}
		true
	}

	def static boolean isGeneric(MatrixType type) {
		try {
			Integer.parseInt(type.height)
			Integer.parseInt(type.width)
		} catch (NumberFormatException e) {
			return true
		}
		false
	}

	def static boolean dimensionsEqual(MatrixType first, MatrixType second) {
		first.height.contentEquals(second.height)
			&& first.width.contentEquals(second.width)
	}

	val private static IntegerType intType = MatrixFactory.eINSTANCE.createIntegerType()

	def static MathematicalType actualEntryType(MatrixType type) {
		type.entryType ?: intType
	}

	def static create(String height, String width, MathematicalType entryType) {
		val matrType = MatrixFactory.eINSTANCE.createMatrixType()
		matrType.height = height
		matrType.width = width
		matrType.entryType = entryType ?: intType
		matrType
	}
}