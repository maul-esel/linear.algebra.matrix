package linear.algebra.matrix.core

import java.util.Objects

class Tuple {
	val Object[] entries

	new(Object... entries) {
		this.entries = entries
	}

	def int getLength() {
		entries.size
	}

	def get(int i) {
		entries.get(i)
	}

	def getEntries() {
		entries.clone // TODO: is correct implementation?
	}

	override equals(Object other) {
		if (other instanceof Tuple)
			other.entries.elementsEqual(entries)
		else false
	}

	override hashCode() {
		entries.fold(0, [ sum, o | sum + Objects.hashCode(o) ])
	}

	override toString() {
		'<' + entries.map [ Objects.toString ].join(', ') + '>'
	}
}