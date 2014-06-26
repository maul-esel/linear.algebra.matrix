package linear.algebra.matrix.semantics

import it.xsemantics.runtime.StringRepresentation

import linear.algebra.matrix.matrix.BooleanType
import linear.algebra.matrix.matrix.IntegerType
import linear.algebra.matrix.matrix.RationalType
import linear.algebra.matrix.matrix.RealType
import linear.algebra.matrix.matrix.ComplexType
import linear.algebra.matrix.matrix.MatrixType

public class MatrixStringRepresentation extends StringRepresentation {
	protected def stringRep(BooleanType t) {
		'boolean'
	}

	protected def stringRep(IntegerType t) {
		'int'
	}

	protected def stringRep(RationalType t) {
		'rational'
	}

	protected def stringRep(RealType t) {
		'real'
	}

	protected def stringRep(ComplexType t) {
		'complex'
	}

	protected def stringRep(MatrixType t) {
		String.format('%s (%s x %s)', string(t.realEntryType), t.height, t.width)
	}
}