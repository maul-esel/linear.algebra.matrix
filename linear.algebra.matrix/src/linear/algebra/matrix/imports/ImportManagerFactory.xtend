package linear.algebra.matrix.imports

import org.eclipse.emf.ecore.resource.Resource

interface ImportManagerFactory {
	def ImportManager create(Resource resource)
}