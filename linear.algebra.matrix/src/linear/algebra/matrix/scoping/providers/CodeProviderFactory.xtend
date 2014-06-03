package linear.algebra.matrix.scoping.providers

import org.eclipse.emf.ecore.resource.ResourceSet

interface CodeProviderFactory {
	def CodeProvider create(ResourceSet context)
}