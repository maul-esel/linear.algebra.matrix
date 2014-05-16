package linear.algebra.matrix.scoping

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.resource.Resource

interface MatrixGlobalScopeFactory {
	def MatrixGlobalScope create(EClass type, Resource origin)
}