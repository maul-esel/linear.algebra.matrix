package linear.algebra.matrix.imports

import java.util.HashMap

import linear.algebra.matrix.matrix.Code

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.resource.IResourceDescription

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class ImportManagerImpl implements ImportManager {
	val Resource resource
	val imports = new HashMap<String, IResourceDescription>()

	@Inject
	IResourceDescription.Manager descrManager

	@Inject
	new(@Assisted Resource resource) {
		this.resource = resource
		readImportNames()
	}

	def private readImportNames() {
		(resource.contents.get(0) as Code).imports.forEach [ imp | imports.put(imp.source, null) ]
	}

	def private importURI(String name) {
		val segments = resource.URI.segments.clone
		segments.set(segments.length - 1, name + ".mtx")
		URI.createHierarchicalURI(resource.URI.scheme, resource.URI.authority, resource.URI.device, segments, null, null)
	}

	def private load(String name) {
		val res = resource.resourceSet.getResource(importURI(name), true)
		imports.put(name, descrManager.getResourceDescription(res))
	}

	def private isLoaded(String name) {
		imports.get(name) != null
	}

	override getImportNames() {
		imports.keySet
	}

	override getImports() {
		importNames.forEach [ name | if (!isLoaded(name)) load(name) ]
		imports.values
	}

	override allImportsValid() {
		importNames.forall [ name | isValidImport(name) ]
	}

	override getImport(String name) {
		if (!existsImport(name))
			throw new IllegalStateException("import of " + name + " does not exist")
		if (!isValidImport(name))
			throw new IllegalStateException("import " + name + " is invalid")
		if (!isLoaded(name))
			load(name)
		imports.get(name)
	}

	override existsImport(String name) {
		imports.containsKey(name)
	}

	override isValidImport(String name) {
		if (!existsImport(name))
			return false
		if (!isLoaded(name))
			try { load(name) }
			catch (Exception e) { return false }
		true
	}

	override getResource() {
		resource
	}
}