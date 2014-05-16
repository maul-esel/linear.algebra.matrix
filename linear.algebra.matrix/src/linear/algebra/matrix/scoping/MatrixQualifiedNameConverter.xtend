package linear.algebra.matrix.scoping

import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.naming.QualifiedName

class MatrixQualifiedNameConverter implements IQualifiedNameConverter {
	override toQualifiedName(String qualifiedNameAsText) {
		QualifiedName.create(qualifiedNameAsText.split("::"))
	}

	override toString(QualifiedName name) {
		name.segments.join("::")
	}
}