package linear.algebra.matrix.interpreter

import java.util.Stack

import linear.algebra.matrix.matrix.MatrixSyntaxElement

import org.eclipse.xtext.nodemodel.util.NodeModelUtils

class StackTrace implements Iterable<StackTrace.Entry> {
	static class Entry {
		protected val String syntax
		protected val int line
		protected val MatrixSyntaxElement elem

		protected new(MatrixSyntaxElement elem) {
			this.elem = elem
			val node = NodeModelUtils.getNode(elem)
			syntax = node?.getText() ?: "[unknown]"
			line = (node?.getStartLine() as Integer) ?: -1
		}

		override toString() {
			String.format('at line %d: %s (code fragment: "%s")', line, elem.eClass.name, formattedSyntax)
		}

		def private formattedSyntax() {
			var result = syntax.trim
			if (result.contains("\n"))
				result = result.substring(0, result.indexOf("\n")) + "..."
			result
		}
	}

	private Stack<StackTrace.Entry> trace = new Stack<Entry>()

	def void enter(MatrixSyntaxElement elem) {
		enter(new Entry(elem))
	}

	def void enter(Entry entry) {
		trace.push(entry)
	}

	def void leave() {
		trace.pop()
	}

	def void leaveAll() {
		trace.clear()
	}

	override iterator() {
		trace.iterator()
	}

	override toString() {
		trace.map [ toString ].reverseView.join("\n")
	}
}