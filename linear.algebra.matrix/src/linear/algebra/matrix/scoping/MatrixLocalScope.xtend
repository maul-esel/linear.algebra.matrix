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

class MatrixLocalScope extends MatrixScope {
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
		super(type)
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

	override _getAllElements() {
		traverse().map [ obj | EObjectDescription.create(prov.getFullyQualifiedName(obj), obj) ]
	}

	override _getElements(QualifiedName name) {
		getAllElements().filter [ descr | name.equals(descr.name) ]
	}

	override _getSingleElement(QualifiedName name) {
		getElements(name).head ?: parentScope.getSingleElement(name)
	}
}