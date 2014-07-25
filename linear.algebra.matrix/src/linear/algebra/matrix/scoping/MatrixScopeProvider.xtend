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

	private val callableScopeCache = new Cache<EObject, IScope>()
	private val varScopeCache  = new Cache<Pair<EObject, EObject>, IScope>()

	override IScope getScope(EObject context, EReference reference) {
		super.getScope(context, reference)
	}

	def scope_CallableRef_ref(Code code, EReference ref) {
		callableScopeCache.get(code, [ t |
			localScopeFactory.create(MatrixPackage.eINSTANCE.callableDeclaration, code, null, globalCallableScope(code), #[])
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

	def private globalCallableScope(EObject obj) {
		globalScopeFactory.create(obj.eResource, MatrixPackage.eINSTANCE.callableDeclaration)
	}
}
