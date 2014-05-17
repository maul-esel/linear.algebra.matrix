package linear.algebra.matrix.scoping

import linear.algebra.matrix.imports.ImportManager

import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class MatrixGlobalScope implements IScope {
	val EClass type
	ImportManager imports

	@Inject
	new(@Assisted EClass type, @Assisted ImportManager imports) {
		this.type = type
		this.imports = imports
	}

	override getAllElements() {
		imports.getImports().map [ descr |
			descr.exportedObjects.filter [ obj | type.isSuperTypeOf(obj.EClass) ]
		].flatten
	}

	override getElements(QualifiedName name) {
		if (name.segments.length == 2 && imports.isValidImport(name.firstSegment)) {
			imports.getImport(name.firstSegment).exportedObjects
			.filter [ obj | type.isSuperTypeOf(obj.EClass) && obj.name.equals(name) ]
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