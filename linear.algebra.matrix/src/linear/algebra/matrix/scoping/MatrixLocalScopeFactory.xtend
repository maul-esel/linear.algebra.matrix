package linear.algebra.matrix.scoping

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.scoping.IScope

import com.google.inject.assistedinject.Assisted

interface MatrixLocalScopeFactory {
	def MatrixLocalScope create(EClass type,
		@Assisted("context") EObject context,
		@Assisted("before") EObject before,
		IScope parentScope,
		Iterable<EObject> additional
	)
}