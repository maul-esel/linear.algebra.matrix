package linear.algebra.matrix.scoping

import linear.algebra.matrix.imports.ImportManager
import linear.algebra.matrix.scoping.providers.CodeProvider

import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class MatrixGlobalScope implements IScope {
	val EClass type
	val ImportManager imports
	val CodeProvider provider

	@Inject
	new(@Assisted EClass type, @Assisted ImportManager imports, @Assisted CodeProvider provider) {
		this.type = type
		this.imports = imports
		this.provider = provider
	}

	override getAllElements() {
		providedElements + imports.getImports().map [ descr | filterType(descr.exportedObjects) ].flatten
	}

	override getElements(QualifiedName name) {
		var list = providedElements
		if (name.segments.length == 2 && imports.isValidImport(name.firstSegment))
			list = list + filterType(imports.getImport(name.firstSegment).exportedObjects)
		list.filter [ obj | obj.name.equals(name) ]
	}

	override getElements(EObject object) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getSingleElement(QualifiedName name) {
		getElements(name).head
	}

	override getSingleElement(EObject object) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	def private providedElements() {
		filterType(provider.functions.map [ o | EObjectDescription.create(o.name, o.func) ]
			+ provider.procs.map [ o | EObjectDescription.create(o.name, o.proc) ])
	}

	def private filterType(Iterable<IEObjectDescription> list) {
		list.filter [ obj | type.isSuperTypeOf(obj.EClass) ]
	}
}