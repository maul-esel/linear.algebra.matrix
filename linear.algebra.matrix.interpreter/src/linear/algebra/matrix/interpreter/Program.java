package linear.algebra.matrix.interpreter;

import linear.algebra.matrix.MatrixStandaloneSetup;

import com.google.inject.Injector;

public class Program {
	public static void main(String[] args) {
		Injector injector = new MatrixStandaloneSetup().createInjectorAndDoEMFRegistration();

		Interpreter interpreter = Interpreter.fromFile(args[0]);
		injector.injectMembers(interpreter);

		interpreter.interpret();
	}
}
