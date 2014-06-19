package linear.algebra.matrix.interpreter.repl

import java.io.InputStream
import java.io.PrintStream

import linear.algebra.matrix.matrix.MatrixFactory
import linear.algebra.matrix.matrix.Code
import linear.algebra.matrix.matrix.Line
import linear.algebra.matrix.matrix.Expression

import linear.algebra.matrix.interpreter.Interpreter
import linear.algebra.matrix.interpreter.InterpreterFactory
import linear.algebra.matrix.interpreter.MatrixException
import linear.algebra.matrix.interpreter.InterpreterException

import linear.algebra.matrix.imports.ImportManager
import linear.algebra.matrix.imports.ImportManagerFactory

import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.Diagnostician
import org.eclipse.emf.common.util.Diagnostic
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.util.StringInputStream

import com.google.inject.Inject

public class REPL {
	public static final String RESOURCE_URI = "__linear.algebra.matrix.interpreter.repl__.mtx"

	@Inject
	private Diagnostician doc

	private val Resource resource
	private val Interpreter interpreter
	private val ImportManager imports
	private StringBuilder code = new StringBuilder()

	private PrintStream out
	private PrintStream err

	@Inject
	public new(ResourceSet resourceSet, InterpreterFactory interpreterFactory, ImportManagerFactory importFactory) {
		resource = resourceSet.createResource(URI.createURI(RESOURCE_URI))

		resource.getContents().add(MatrixFactory.eINSTANCE.createCode()) // needed so interpreter won't fail
		interpreter = interpreterFactory.create(resource)
		imports = importFactory.create(resource)
	}

	def void start(InputStream in, PrintStream out, PrintStream err) {
		this.out = out
		this.err = err
		while (true) {
			val oldCode = new StringBuilder(code.toString())

			out.print(">> ")
			out.flush()
			val line = readNextStatement(in).trim()

			val isImport =line.startsWith("import")
			if (isImport)
				code.insert(0, line + '\n')
			else
				code.append('\n' + line)

			resource.unload()
			resource.load(new StringInputStream(code.toString()), null)

			EcoreUtil2.resolveLazyCrossReferences(resource, CancelIndicator.NullImpl)
			val diagnostic = doc.validate(root)
			if (resource.errors.size > 0 || diagnostic.severity == Diagnostic.ERROR) {
				code = oldCode
				for (d: resource.errors)
					error("ERROR:\n" + errorMessage(d))
				if (diagnostic.severity == Diagnostic.ERROR)
					error("ERROR:\n" + errorMessage(diagnostic))
			} else if (!isImport)
				handle(root().lines.last)
			else
				output("successfully imported")
		}
	}

	private def root() {
		resource.contents.get(0) as Code
	}

	private def dispatch handle(Line line) {
		try {
			interpreter.interpret(line)
			output("successfully executed")
		} catch (MatrixException e) {
			error("ERROR: " + e.message + "\n" + e.languageStackTrace.toString())
			e.languageStackTrace.leaveAll() // reset, so that future exceptions don't share the trace
		} catch (InterpreterException e) {
			error("ERROR: " + e.message + "\n" + e.languageStackTrace.toString())
			e.languageStackTrace.leaveAll() // reset, so that future exceptions don't share the trace
		} catch (Exception e) {
			error("ERROR:\n" + e.message)
		}
	}

	private def dispatch handle(Expression expr) {
		try {
			val value = interpreter.evaluate(expr)
			output("=> " + value)
		} catch (MatrixException e) {
			error("ERROR: " + e.message + "\n" + e.languageStackTrace.toString())
			e.languageStackTrace.leaveAll() // reset, so that future exceptions don't share the trace
		} catch (InterpreterException e) {
			error("ERROR: " + e.message + "\n" + e.languageStackTrace.toString())
			e.languageStackTrace.leaveAll() // reset, so that future exceptions don't share the trace
		} catch (Exception e) {
			error("ERROR:\n" + e.message)
		}
	}

	private static val readAfterBlock = #[' ', ';', '\t'].map[ charAt(0) ]

	private def String readNextStatement(InputStream s) {
		val in = new PeekReader(s)
		if (in.isAtEOF())
			return ""

		val result = new StringBuilder()

		var ch = in.peekChar()
		while (!in.isAtEOF() && ch != ';'.charAt(0)) {
			result.append(in.readChar())

			if (ch == '{'.charAt(0)) {
				result.append(readBlock(in))

				if (!in.isAtEOF())
					for (ch = in.peekChar(); !in.isAtEOF() && readAfterBlock.contains(ch); ch = in.peekChar())
						result.append(in.readChar())
				return result.toString()
			}
			ch = in.peekChar()
		}
		if (!in.isAtEOF())
			result.append(in.readChar()) // append semicolon

		result.toString()
	}

	private def String readBlock(PeekReader in) {
		val result = new StringBuilder()

		var ch = in.peekChar()
		while (!in.isAtEOF() && ch != '}'.charAt(0)) {
			result.append(in.readChar())
			if (ch == '{'.charAt(0))
				result.append(readBlock(in))
			ch = in.peekChar()
		}
		if (!in.isAtEOF())
			result.append(in.readChar()) // add closing bracket

		result.toString()
	}

	private def errorMessage(Resource.Diagnostic d) {
		d.message
	}

	private def errorMessage(Diagnostic d) {
		if (d.children.size > 0)
			"problems:\n" + d.children.map [ "* " + message ].join("\n")
		else d.message
	}

	private def output(String s) {
		out.println(comment(s))
		out.flush()
	}

	private def error(String s) {
		err.println(comment(s))
		err.flush()
	}

	private def comment(String s) {
		if (s.contains("\n"))
			"§§ " + s + "\n§§"
		else
			"§ " + s
	}
}
