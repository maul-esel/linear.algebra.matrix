package linear.algebra.matrix.scoping

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.EClass

interface MatrixGlobalScopeFactory {
	def MatrixGlobalScope create(Resource resource, EClass type)
}