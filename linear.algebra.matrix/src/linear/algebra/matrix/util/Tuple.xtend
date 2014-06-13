package linear.algebra.matrix.util

import java.util.Objects

package abstract class Tuple {
	val Object[] entries

	protected new(Object... entries) {
		this.entries = entries
	}

	override equals(Object other) {
		if (other instanceof Tuple)
			entries.elementsEqual(other.entries)
		else
			false
	}

	override hashCode() {
		entries.fold(42, [ h, entry | h + Objects.hashCode(entry) ])
	}
}