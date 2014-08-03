package linear.algebra.matrix.imports

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.emf.ecore.resource.Resource

interface ImportManager {
	def Iterable<String> getImportNames()
	def Iterable<IResourceDescription> getImports()
	def boolean allImportsValid()

	def IResourceDescription getImport(String name)
	def boolean existsImport(String name) // does an "import ..." directive exist?
	def boolean isValidImport(String name) // ... && can the imported file be found?

	def QualifiedName translateQualifiedName(QualifiedName name)

	def Resource getResource()
}