package linear.algebra.matrix.scoping

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.scoping.IScope

interface MatrixLocalScopeFactory {
	def MatrixLocalScope create(EClass type, EObject context, IScope parentScope, Iterable<EObject> additional)
}