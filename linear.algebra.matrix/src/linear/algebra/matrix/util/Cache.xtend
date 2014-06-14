package linear.algebra.matrix.util

import java.util.HashMap

class Cache<K, V> {
	private val contents = new HashMap<K, V>()

	def boolean isCached(K key) {
		contents.containsKey(key)
	}

	def V get(K key) {
		contents.get(key)
	}

	def void add(K key, V value) {
		contents.put(key, value)
	}

	def V get(K key, (K)=>V create) {
		if (!isCached(key))
			add(key, create.apply(key))
		get(key)
	}

	def void clear() {
		contents.clear()
	}
}