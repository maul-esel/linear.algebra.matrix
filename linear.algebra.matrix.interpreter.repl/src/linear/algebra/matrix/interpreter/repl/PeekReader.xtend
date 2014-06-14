package linear.algebra.matrix.interpreter.repl

import java.io.Reader
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader

class PeekReader extends BufferedReader {
	private var Integer currentChar = null

	new(Reader reader) {
		super(reader, 1)
	}

	new(InputStream in) {
		this(new InputStreamReader(in))
	}

	override int read() {
		currentChar = null
		super.read()
	}

	override mark(int limit) {
		throw new IOException()
	}

	override markSupported() {
		false
	}

	override reset() {
		throw new IOException()
	}

	def char readChar() {
		read() as char
	}

	def int peek() {
		if (currentChar == null) {
			super.mark(1) // call super directly to avoid exception in overridden method
			currentChar = read()
			super.reset() // (as above)
		}
		return currentChar
	}

	def char peekChar() {
		peek() as char
	}

	def boolean isAtEOF() {
		peek() == -1
	}
}