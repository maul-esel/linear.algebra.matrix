package linear.algebra.matrix.scoping

import linear.algebra.matrix.util.Cache
import linear.algebra.matrix.util.Pair

import linear.algebra.matrix.matrix.Code
import linear.algebra.matrix.matrix.Block
import linear.algebra.matrix.matrix.Variable
import linear.algebra.matrix.matrix.FuncDeclaration
import linear.algebra.matrix.matrix.ProcDeclaration
import linear.algebra.matrix.matrix.MatrixInit
import linear.algebra.matrix.matrix.MatrixPackage

import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.scoping.IScope

import com.google.inject.Inject

class MatrixScopeProvider extends org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider {
	@Inject MatrixGlobalScopeFactory globalScopeFactory
	@Inject MatrixLocalScopeFactory localScopeFactory

	private val funcScopeCache = new Cache<EObject, IScope>()
	private val procScopeCache = new Cache<EObject, IScope>()
	private val varScopeCache  = new Cache<Pair<EObject, EObject>, IScope>()

	def scope_Function_ref(Code code, EReference ref) {
		funcScopeCache.get(code, [ t |
			localScopeFactory.create(MatrixPackage.eINSTANCE.funcDeclaration, code, null, globalFuncScope(code), #[])
		])
	}

	def scope_ProcRef_ref(Code code, EReference ref) {
		procScopeCache.get(code, [ t |
			localScopeFactory.create(MatrixPackage.eINSTANCE.procDeclaration, code, null, globalProcScope(code), #[])
		])
	}

	def scope_Variable_ref(Variable variable, EReference ref) {
		scopeVariable(variable, variable, ref)
	}

	def private dispatch IScope scopeVariable(EObject context, EObject before, EReference ref) {
		scopeVariable(context.eContainer, context, ref)
	}

	def private dispatch IScope scopeVariable(Block block, EObject before, EReference ref) {
		varScopeCache.get(pair(block, before), [ t |
			localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, block, before, scopeVariable(block.eContainer, block, ref), #[])
		])
	}

	def private dispatch IScope scopeVariable(MatrixInit init, EObject before, EReference ref) {
		varScopeCache.get(pair(init, before), [ t |
			localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, init, before, scopeVariable(init.eContainer, init, ref), #[])
		])
	}

	def private dispatch IScope scopeVariable(Code code, EObject before, EReference ref) {
		varScopeCache.get(pair(code, before), [ t |
			localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, code, before, IScope.NULLSCOPE, #[])
		])
	}

	def private dispatch IScope scopeVariable(FuncDeclaration decl, EObject before, EReference ref) {
		varScopeCache.get(pair(decl, before), [ t |
			localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, decl, before, IScope.NULLSCOPE, decl.params.params.filter(EObject))
		])
	}

	def private dispatch IScope scopeVariable(ProcDeclaration proc, EObject before, EReference ref) {
		varScopeCache.get(pair(proc, before), [ t|
			localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, proc, before, IScope.NULLSCOPE, proc.params.params.filter(EObject))
		])
	}

	def private pair(EObject a, EObject b) {
		new Pair<EObject, EObject>(a, b)
	}

	def private globalFuncScope(EObject obj) {
		globalScopeFactory.create(obj.eResource, MatrixPackage.eINSTANCE.funcDeclaration)
	}

	def private globalProcScope(EObject obj) {
		globalScopeFactory.create(obj.eResource, MatrixPackage.eINSTANCE.procDeclaration)
	}
}
