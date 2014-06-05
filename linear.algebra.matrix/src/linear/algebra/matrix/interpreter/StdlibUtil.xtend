package linear.algebra.matrix.interpreter

import linear.algebra.matrix.matrix.*

import linear.algebra.matrix.scoping.MatrixGlobalScopeFactory
import linear.algebra.matrix.imports.ImportManagerFactory

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.util.EcoreUtil

import com.google.inject.Inject

class StdlibUtil {
	static val matrixMult    = QualifiedName.create('stdlib', 'mult')
	static val scalarMult    = QualifiedName.create('stdlib', 'scalar_mult')
	static val matrixAdd     = QualifiedName.create('stdlib', 'add')
	static val matrixNeg     = QualifiedName.create('stdlib', 'minus')
	static val matrixExp     = QualifiedName.create('stdlib', 'exp')
	static val Transposition = QualifiedName.create('stdlib', 'transpose')
	static val Equivalency   = QualifiedName.create('stdlib', 'equivalent')
	static val Determinant   = QualifiedName.create('stdlib', 'det')

	@Inject
	MatrixGlobalScopeFactory scopeFactory

	@Inject
	ImportManagerFactory importFactory

	def createMatrixMultiplication(Multiplication mult) {
		createFunctionCall(mult.eResource, matrixMult, #[mult.left, mult.right])
	}

	def createScalarMultiplication(Multiplication mult, Expression scalar) {
		val matrix = if (mult.left == scalar) mult.right else mult.left
		createFunctionCall(mult.eResource, scalarMult, #[matrix, scalar])
	}

	def createMatrixAddition(Addition add) {
		createFunctionCall(add.eResource, matrixAdd, #[add.left, add.right])
	}

	def createMatrixSubtraction(Addition add) {
		createFunctionCall(add.eResource, matrixAdd, #[add.left, createMatrixNegative(add.right)])
	}

	def createMatrixNegative(Expression expr) {
		createFunctionCall(expr.eResource, matrixNeg, #[expr])
	}

	def createMatrixExp(Exponentiation exp) {
		createFunctionCall(exp.eResource, matrixExp, #[exp.base, exp.exp])
	}

	def createTransposition(Transposition trans) {
		createFunctionCall(trans.eResource, Transposition, #[trans.expr])
	}

	def createEquivalency(Equivalency eq) {
		createFunctionCall(eq.eResource, Equivalency, #[eq.left, eq.right])
	}

	def createDeterminant(DeterminantOrAbsoluteValue expr) {
		createFunctionCall(expr.eResource, Determinant, #[expr.expr])
	}

	def private createFunctionCall(Resource res, QualifiedName name, Expression[] params) {
		val func = MatrixFactory.eINSTANCE.createFunction()
		func.ref = query(res, MatrixPackage.eINSTANCE.funcDeclaration, name) as FuncDeclaration

		val call = MatrixFactory.eINSTANCE.createFunctionCall()
		call.func = func;

		params.forEach [ p | call.params.add(p) ]

		call
	}

	def private EObject query(Resource res, EClass type, QualifiedName name) {
		val manager = importFactory.create(res) // get an importManager
		val scope = scopeFactory.create(type, manager) // get a global scope
		var objOrProxy = scope.getSingleElement(name).EObjectOrProxy // query global scope
		if (objOrProxy.eIsProxy)
			objOrProxy = EcoreUtil.resolve(objOrProxy, res.resourceSet)
		objOrProxy
	}
}