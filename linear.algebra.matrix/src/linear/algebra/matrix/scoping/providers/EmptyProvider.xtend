package linear.algebra.matrix.scoping.providers

import org.eclipse.emf.ecore.resource.Resource

public class EmptyProvider implements CodeProvider {
	override getFunctionsFor(Resource res) {
		#[]
	}

	override getProcsFor(Resource res) {
		#[]
	}

	override interpretFunction(Resource res, Function func, Object[] parameters) {
		throw new UnsupportedOperationException("Function interpretation not supported")
	}

	override interpretProc(Resource res, Proc proc, Object[] parameters) {
		throw new UnsupportedOperationException("Proc interpretation not supported")
	}
}