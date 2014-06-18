package linear.algebra.matrix.interpreter

import java.util.Stack

import linear.algebra.matrix.matrix.MatrixSyntaxElement
import linear.algebra.matrix.matrix.FuncDeclaration
import linear.algebra.matrix.matrix.ProcDeclaration
import linear.algebra.matrix.matrix.UnaryExpression
import linear.algebra.matrix.matrix.BinaryExpression

import org.eclipse.xtext.nodemodel.util.NodeModelUtils

class StackTrace implements Iterable<StackTrace.Entry> {
	static class Entry {
		protected val String syntax
		protected val int line
		protected val MatrixSyntaxElement elem

		protected new(MatrixSyntaxElement elem) {
			this.elem = elem
			val node = NodeModelUtils.getNode(elem)
			syntax = node.getText()
			line = node.getStartLine()
		}

		override toString() {
			String.format("at line %i: %s (code fragment: '%s')", line, elem.eClass.name, syntax)
		}
	}

	private Stack<StackTrace.Entry> trace;

	def void enter(MatrixSyntaxElement elem) {
		enter(new Entry(elem))
	}

	def void enter(Entry entry) {
		trace.push(entry)
	}

	def void leave() {
		trace.pop()
	}

	override iterator() {
		trace.iterator()
	}

	override toString() {
		trace.map [ toString ].join("\n")
	}
}