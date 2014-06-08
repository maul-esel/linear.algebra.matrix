package linear.algebra.matrix.scoping.providers

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.resource.Resource

import linear.algebra.matrix.matrix.Type
import linear.algebra.matrix.matrix.MatrixFactory
import linear.algebra.matrix.matrix.FuncDeclaration

@Data public class Function extends Callable {
	FuncDeclaration func

	def static createSymbolic(Resource context, QualifiedName name, Type[] params, Type returnType) {
		val func = MatrixFactory.eINSTANCE.createFuncDeclaration()
		context.contents.add(func)
		func.internal  = false;
		func.name       = name.lastSegment
		func.returnType = returnType
		func.params     = createParamList(context, params)
		func.body       = MatrixFactory.eINSTANCE.createBlock()

		new Function(name, InterpretationMethod.Provider, func)
	}
}
