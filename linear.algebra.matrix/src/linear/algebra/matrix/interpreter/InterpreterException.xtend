package linear.algebra.matrix.interpreter;

class InterpreterException extends Exception {
	val StackTrace trace

	new(String message, StackTrace trace) {
		this(message, null, trace)
	}

	new(String message, Throwable cause, StackTrace trace) {
		super(message, cause)
		this.trace = trace
	}

	def getLanguageStackTrace() {
		trace
	}

	def printLanguageStackTrace() {
		System.err.println(getMessage() + "\n" + trace.toString())
	}
}