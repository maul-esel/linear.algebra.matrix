package linear.algebra.matrix.scoping

import linear.algebra.matrix.matrix.Code

import java.util.Map
import java.util.HashMap

import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.common.util.URI

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class MatrixGlobalScope implements IScope {
	val EClass type
	val Resource origin
	var Map<String, Resource> importedResources

	@Inject
	ResourceDescriptionsProvider descrProvider

	@Inject
	new(@Assisted EClass type, @Assisted Resource origin) {
		this.type = type
		this.origin = origin
	}

	def private getImports() {
		if (importedResources == null) {
			importedResources = new HashMap<String, Resource>()
			for (imp : (origin.contents.get(0) as Code).imports) // do manually because XTend .map, .toMap throw exceptions
				importedResources.put(imp.source, origin.resourceSet.getResource(importURI(imp.source), true))
		}
		importedResources
	}

	def private importURI(String name) {
		val segments = origin.URI.segments.clone
		segments.set(segments.length - 1, name + ".mtx")
		URI.createHierarchicalURI(origin.URI.scheme, origin.URI.authority, origin.URI.device, segments, null, null)
	}

	override getAllElements() {
		throw new UnsupportedOperationException("cannot enumerate scope")
	}

	override getElements(QualifiedName name) {
		if (name.segments.length == 2 && imports.containsKey(name.firstSegment)) {
			descrProvider.getResourceDescriptions(imports.get(name.firstSegment))
				.allResourceDescriptions
				.map [ descr |
					descr.exportedObjects.filter [ obj | type.isSuperTypeOf(obj.EClass) && obj.name.equals(name) ]
				].flatten
		} else #[]
	}

	override getElements(EObject object) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getSingleElement(QualifiedName name) {
		getElements(name).findFirst [ true ]
	}

	override getSingleElement(EObject object) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}