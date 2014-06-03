package linear.algebra.matrix.scoping.providers

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.resource.Resource

import linear.algebra.matrix.matrix.MatrixFactory
import linear.algebra.matrix.matrix.Type

@Data package abstract class Callable {
	QualifiedName name
	InterpretationMethod interpretationMethod

	protected static def createParamList(Resource context, Type[] params) {
		val paramList = MatrixFactory.eINSTANCE.createParameterList()
		context.contents.add(paramList)
		for (i : 0..<params.size) {
			val paramDecl = MatrixFactory.eINSTANCE.createTypedVarDeclaration()
			context.contents.add(paramDecl)
			paramDecl.const = false
			paramDecl.name  = "__param__" + i
			paramDecl.value = null
			paramDecl.type  = params.get(i)
			paramList.params.add(paramDecl)
		}
		paramList
	}
}