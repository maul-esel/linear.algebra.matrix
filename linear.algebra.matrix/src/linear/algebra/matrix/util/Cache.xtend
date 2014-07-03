package linear.algebra.matrix.util

import java.util.HashMap

class Cache<K, V> {
	private static class Entry<V> {
		var int priority = 1
		val int factor
		val V value

		new(V value, int factor) {
			this.value = value
			this.factor = factor
		}

		def Entry<V> increase() {
			priority+=factor
			this
		}
	}

	new() {
		this(-1)
	}

	new(int max) {
		capacity = max
	}

	private val int capacity

	private val contents = new HashMap<K, Entry<V>>()

	def boolean isCached(K key) {
		contents.containsKey(key)
	}

	def V get(K key) {
		contents.get(key)?.increase().value
	}

	def V get(K key, (K)=>V create) {
		get(key, create, 1)
	}

	def V get(K key, (K)=>V create, int factor) {
		if (!isCached(key))
			add(key, create.apply(key), factor)
		get(key)
	}

	def void add(K key, V value) {
		add(key, value, 1)
	}

	def void add(K key, V value, int factor) {
		if (contents.size == capacity)
			pop()
		contents.put(key, new Entry(value, factor))
	}

	def void clear() {
		contents.clear()
	}

	private def void pop() {
		val k = contents.entrySet.sortBy [ value.priority ].head?.key // sort by priority ASCENDING, get lowest entry key
		if (k != null)
			contents.remove(k)
	}
}