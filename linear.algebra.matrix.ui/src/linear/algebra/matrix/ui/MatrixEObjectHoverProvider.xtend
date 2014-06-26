package linear.algebra.matrix.ui

import linear.algebra.matrix.matrix.TypedVarDeclaration
import linear.algebra.matrix.matrix.InferredVarDeclaration
import linear.algebra.matrix.matrix.Variable
import linear.algebra.matrix.matrix.ProcDeclaration
import linear.algebra.matrix.matrix.FuncDeclaration
import linear.algebra.matrix.matrix.ParameterList

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider

import linear.algebra.matrix.semantics.*

import it.xsemantics.runtime.StringRepresentation

import com.google.inject.Inject

public class MatrixEObjectHoverProvider extends DefaultEObjectHoverProvider {
	@Inject var Typing typeProvider
	@Inject StringRepresentation str

	override getFirstLine(EObject obj) {
		firstLine(obj)
	}

	protected def dispatch String firstLine(EObject obj) {
		super.getFirstLine(obj)
	}

	protected def dispatch String firstLine(TypedVarDeclaration decl) {
		(if (decl.const) 'const ' else '') + str.string(decl.type) + " <b>" + decl.name + "</b>"
	}

	protected def dispatch String firstLine(InferredVarDeclaration decl) {
		(if (decl.const) 'const ' else '') + str.string(typeProvider.vartype(decl).value) + " <b>" + decl.name + "</b>"
	}

	protected def dispatch String firstLine(Variable variable) {
		firstLine(variable.ref)
	}

	protected def dispatch String firstLine(ProcDeclaration decl) {
		'proc <b>' + decl.name + '</b>(' + params(decl.params) + ')'
	}

	protected def dispatch String firstLine(FuncDeclaration decl) {
		'function <b>' + decl.name + '</b>(' + params(decl.params) + ') -> ' + str.string(decl.returnType)
	}

	private def String params(ParameterList params) {
		params.params.map [ str.string(type) + ' ' + name ].join(', ')
	}
}