package linear.algebra.matrix.scoping

import linear.algebra.matrix.imports.ImportManager
import linear.algebra.matrix.imports.ImportManagerFactory
import linear.algebra.matrix.scoping.providers.CodeProvider

import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.resource.Resource

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class MatrixGlobalScope extends MatrixScope {
	val Resource resource

	var ImportManager importManager

	@Inject
	private var CodeProvider provider

	@Inject
	new(@Assisted Resource resource, @Assisted EClass type, ImportManagerFactory importFactory) {
		super(type)
		this.resource = resource
		importManager = importFactory.create(resource)
	}

	override _getAllElements() {
		providedElements + importManager.getImports().map [ descr | filterType(descr.exportedObjects) ].flatten
	}

	override _getElements(QualifiedName qname) {
		val name = importManager.translateQualifiedName(qname)
		var list = providedElements
		if (name.segments.length == 2 && importManager.isValidImport(qname.firstSegment))
			list = list + filterType(importManager.getImport(qname.firstSegment).exportedObjects)
		list.filter [ obj | obj.name.equals(name) ]
	}

	override _getSingleElement(QualifiedName name) {
		getElements(name).head
	}

	def private providedElements() {
		filterType(provider.getFunctionsFor(resource).map [ o | EObjectDescription.create(o.name, o.func) ]
			+ provider.getProcsFor(resource).map [ o | EObjectDescription.create(o.name, o.proc) ])
	}

	def private filterType(Iterable<IEObjectDescription> list) {
		list.filter [ obj | type.isSuperTypeOf(obj.EClass) ]
	}
}