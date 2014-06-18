package linear.algebra.matrix.interpreter;

class MatrixException extends Exception {
	val StackTrace trace

	new(String message, StackTrace trace) {
		super(message)
		this.trace = trace
	}

	def getLanguageStackTrace() {
		trace
	}

	def printLanguageStackTrace() {
		System.err.println(getMessage() + "\n" + trace.toString())
	}
}