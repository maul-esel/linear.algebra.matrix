package linear.algebra.matrix.scoping

import linear.algebra.matrix.matrix.Code
import linear.algebra.matrix.matrix.FuncDeclaration
import linear.algebra.matrix.matrix.ProcDeclaration

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy
import org.eclipse.xtext.util.IAcceptor
import org.eclipse.xtext.naming.QualifiedName

class MatrixResourceDescriptionStrategy extends DefaultResourceDescriptionStrategy {
	override createEObjectDescriptions(EObject eObject, IAcceptor<IEObjectDescription> acceptor) {
		val module = eObject.eResource.URI.trimFileExtension.segments.last;
		if (eObject instanceof ProcDeclaration) {
			if (!eObject.internal)
				acceptor.accept(EObjectDescription.create(QualifiedName.create(module, eObject.name), eObject))
		} else if (eObject instanceof FuncDeclaration) {
			if (!eObject.internal)
				acceptor.accept(EObjectDescription.create(QualifiedName.create(module, eObject.name), eObject))
		}
		(eObject instanceof Code) // only Code instances are traversed
	}
}