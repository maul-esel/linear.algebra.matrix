/*
 * generated by Xtext
 */
package linear.algebra.matrix.scoping

import linear.algebra.matrix.matrix.Code
import linear.algebra.matrix.matrix.Block
import linear.algebra.matrix.matrix.FuncDeclaration
import linear.algebra.matrix.matrix.ProcDeclaration
import linear.algebra.matrix.matrix.MatrixInit
import linear.algebra.matrix.matrix.MatrixPackage

import linear.algebra.matrix.imports.ImportManagerFactory

import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.scoping.IScope

import com.google.inject.Inject

class MatrixScopeProvider extends org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider {
	@Inject MatrixGlobalScopeFactory globalScopeFactory
	@Inject MatrixLocalScopeFactory localScopeFactory
	@Inject ImportManagerFactory importFactory

	def scope_Function_ref(Code code, EReference ref) {
		localScopeFactory.create(MatrixPackage.eINSTANCE.funcDeclaration, code, globalFuncScope(code), #[])
	}

	def scope_ProcRef_ref(Code code, EReference ref) {
		localScopeFactory.create(MatrixPackage.eINSTANCE.procDeclaration, code, globalProcScope(code), #[])
	}

	def scope_Variable_ref(Block block, EReference ref) {
		localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, block, getScope(block.eContainer, ref), #[])
	}

	def scope_Variable_ref(MatrixInit init, EReference ref) {
		localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, init, getScope(init.eContainer, ref), #[])
	}

	def scope_Variable_ref(Code code, EReference ref) {
		localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, code, globalVarScope(code), #[])
	}

	def scope_Variable_ref(FuncDeclaration decl, EReference ref) {
		localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, decl, IScope.NULLSCOPE, decl.params.params.map [ obj | obj ])
	}

	def scope_Variable_ref(ProcDeclaration proc, EReference ref) {
		localScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, proc, IScope.NULLSCOPE, proc.params.params.map [ obj | obj ])
	}

	def private globalFuncScope(EObject obj) {
		globalScopeFactory.create(MatrixPackage.eINSTANCE.funcDeclaration, importFactory.create(obj.eResource))
	}

	def private globalProcScope(EObject obj) {
		globalScopeFactory.create(MatrixPackage.eINSTANCE.procDeclaration, importFactory.create(obj.eResource))
	}

	def private globalVarScope(EObject obj) {
		globalScopeFactory.create(MatrixPackage.eINSTANCE.varDeclaration, importFactory.create(obj.eResource))
	}
}
