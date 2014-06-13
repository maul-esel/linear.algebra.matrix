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
	private var ImportManagerFactory importFactory

	@Inject
	new(@Assisted Resource resource, @Assisted EClass type) {
		super(type)
		this.resource = resource
	}

	override _getAllElements() {
		providedElements + imports.getImports().map [ descr | filterType(descr.exportedObjects) ].flatten
	}

	override _getElements(QualifiedName name) {
		var list = providedElements
		if (name.segments.length == 2 && imports.isValidImport(name.firstSegment))
			list = list + filterType(imports.getImport(name.firstSegment).exportedObjects)
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

	def private imports() {
		if (importManager == null)
			importManager = importFactory.create(resource)
		importManager
	}
}