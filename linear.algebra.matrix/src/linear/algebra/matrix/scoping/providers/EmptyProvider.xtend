package linear.algebra.matrix.scoping.providers

import org.eclipse.emf.ecore.resource.ResourceSet

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

public class EmptyProvider implements CodeProvider {
	private val ResourceSet resourceSet

	@Inject
	new(@Assisted ResourceSet resourceSet) {
		this.resourceSet = resourceSet
	}

	override getResourceSet() {
		resourceSet
	}

	override getFunctions() {
		#[]
	}

	override getProcs() {
		#[]
	}

	override interpretFunction(Function func, Object[] parameters) {
		throw new UnsupportedOperationException("Function interpretation not supported")
	}

	override interpretProc(Proc proc, Object[] parameters) {
		throw new UnsupportedOperationException("Proc interpretation not supported")
	}
}