package linear.algebra.matrix.interpreter

import org.eclipse.emf.ecore.resource.Resource

interface InterpreterFactory {
	def Interpreter create(Resource resource)
}