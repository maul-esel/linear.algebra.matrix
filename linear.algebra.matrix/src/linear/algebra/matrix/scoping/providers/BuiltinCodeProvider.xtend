package linear.algebra.matrix.scoping.providers

import linear.algebra.matrix.core.Matrix

import org.eclipse.emf.ecore.resource.ResourceSet

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class BuiltinCodeProvider extends AbstractDeclarativeProvider {
	@Inject
	new(@Assisted ResourceSet resourceSet) {
		super(resourceSet)
	}

	def void proc_printBoolean(boolean b) {
		System.out.println(b)
	}

	def void proc_printNumber(Number n) {
		System.out.println(n)
	}

	def void proc_printMatrix(Matrix<?> m) {
		System.out.println(m)
	}
}