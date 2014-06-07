package linear.algebra.matrix.scoping

import java.util.ArrayList

import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted
import javax.annotation.Nullable

class MatrixLocalScope implements IScope {
	val EClass type
	val EObject context
	val EObject before
	val IScope parentScope
	val Iterable<EObject> additional

	var Iterable<EObject> objects

	@Inject IQualifiedNameProvider prov

	@Inject
	new(@Assisted EClass type,
		@Assisted("context") EObject context,
		@Nullable @Assisted("before") EObject before,
		@Assisted IScope parentScope,
		@Assisted Iterable<EObject> additional
	) {
		this.type = type
		this.context = context
		this.parentScope = parentScope
		this.additional = additional
		this.before = before
	}

	def private traverse() {
		if (objects == null)
			objects = (filterBefore(context.eContents) + additional).filter [ obj | type.isSuperTypeOf(obj.eClass) ]
		objects
	}

	def private filterBefore(Iterable<EObject> list) {
		val newList = new ArrayList<EObject>()
		for (var i = 0; i < list.size && list.get(i) != before; i++)
			newList.add(list.get(i))
		newList
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
		getElements(name).head ?: parentScope.getSingleElement(name)
	}

	override getSingleElement(EObject object) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}