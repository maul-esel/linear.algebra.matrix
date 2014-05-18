package linear.algebra.matrix.interpreter

import linear.algebra.matrix.matrix.ComparisonOp

static class CompareUtil {
	def static <T> boolean compare(Comparable<T> left, T right, ComparisonOp op) {
		switch op {
			case ComparisonOp.LESS: left < right
			case ComparisonOp.GREATER : left > right
			case ComparisonOp.LESSOREQUAL : left <= right
			case ComparisonOp.GREATEROREQUAL : left >= right
			default: throw new UnsupportedOperationException()
		}
	}
}