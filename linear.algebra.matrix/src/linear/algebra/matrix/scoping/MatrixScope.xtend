package linear.algebra.matrix.scoping

import linear.algebra.matrix.util.Cache

import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass

package abstract class MatrixScope implements IScope {
	protected val EClass type

	val singleCache = new Cache<QualifiedName, IEObjectDescription>()
	val multiCache = new Cache<QualifiedName, Iterable<IEObjectDescription>>()

	new(EClass type) {
		this.type = type
	}

	private var Iterable<IEObjectDescription> _allElements = null

	override getAllElements() {
		if (_allElements == null)
			_allElements = _getAllElements()
		_allElements
	}

	override getElements(QualifiedName name) {
		multiCache.get(name, [ n | _getElements(n) ])
	}

	override getSingleElement(QualifiedName name) {
		singleCache.get(name, [ n | _getSingleElement(n) ])
	}

	override getElements(EObject object) {
		throw new UnsupportedOperationException()
	}

	override getSingleElement(EObject object) {
		throw new UnsupportedOperationException()
	}

	abstract def Iterable<IEObjectDescription> _getAllElements()
	abstract def Iterable<IEObjectDescription> _getElements(QualifiedName name)
	abstract def IEObjectDescription _getSingleElement(QualifiedName name)
}