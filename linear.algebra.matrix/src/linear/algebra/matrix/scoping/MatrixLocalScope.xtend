package linear.algebra.matrix.scoping

import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class MatrixLocalScope implements IScope {
	val EClass type
	val EObject context
	val IScope parentScope
	val Iterable<EObject> additional

	var Iterable<EObject> objects

	@Inject IQualifiedNameProvider prov

	@Inject
	new(@Assisted EClass type, @Assisted EObject context, @Assisted IScope parentScope, @Assisted Iterable<EObject> additional) {
		this.type = type
		this.context = context
		this.parentScope = parentScope
		this.additional = additional
	}

	def private traverse() {
		if (objects == null)
			objects = (context.eContents + additional).filter [ obj | type.isSuperTypeOf(obj.eClass) ]
		objects
	}

	override getAllElements() {
		throw new UnsupportedOperationException("cannot enumerate scope")
	}

	override getElements(QualifiedName name) {
		traverse()
			.filter [ obj | name.equals(prov.getFullyQualifiedName(obj)) ]
			.map [ obj | EObjectDescription.create(name, obj) ]
	}

	override getElements(EObject object) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getSingleElement(QualifiedName name) {
		getElements(name).findFirst [ true ] ?: parentScope.getSingleElement(name)
	}

	override getSingleElement(EObject object) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}