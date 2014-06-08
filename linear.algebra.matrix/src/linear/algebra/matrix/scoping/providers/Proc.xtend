package linear.algebra.matrix.scoping.providers

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.resource.Resource

import linear.algebra.matrix.matrix.MatrixFactory
import linear.algebra.matrix.matrix.ProcDeclaration
import linear.algebra.matrix.matrix.Type

@Data public class Proc extends Callable {
	ProcDeclaration proc

	def static createSymbolic(Resource context, QualifiedName name, Type[] params) {
		val proc = MatrixFactory.eINSTANCE.createProcDeclaration()
		context.contents.add(proc)
		proc.internal  = false;
		proc.name       = name.lastSegment
		proc.params     = createParamList(context, params)
		proc.body       = MatrixFactory.eINSTANCE.createBlock()

		new Proc(name, InterpretationMethod.Provider, proc)
	}
}