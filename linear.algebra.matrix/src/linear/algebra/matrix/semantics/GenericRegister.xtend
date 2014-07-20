package linear.algebra.matrix.semantics

import java.util.HashMap

import linear.algebra.matrix.matrix.MathematicalType
import linear.algebra.matrix.matrix.GenericType

class GenericRegister {
	val typeMap = new HashMap<GenericType, MathematicalType>()
	val numberMap = new HashMap<String, String>()

	def existsType(String name) {
		typeMap.containsKey(name)
	}

	def existsNumber(String variable) {
		numberMap.containsKey(variable)
	}

	def getTypes() {
		typeMap.keySet
	}

	def getNumbers() {
		numberMap.keySet
	}

	def void putType(GenericType key, MathematicalType value) {
		typeMap.put(key, value)
	}

	def void putNumber(String key, String value) {
		if (!key.startsWith("$"))
			throw new UnsupportedOperationException("Invalid generic variable")
		numberMap.put(key, value)
	}

	def getType(GenericType key) {
		typeMap.get(key)
	}

	def getNumber(String key) {
		if (!existsNumber(key))
			throw new UnsupportedOperationException("Generic variable unknown")
		numberMap.get(key)
	}
}