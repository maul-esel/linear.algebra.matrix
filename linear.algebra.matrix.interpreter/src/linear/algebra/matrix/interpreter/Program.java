package linear.algebra.matrix.interpreter;

public class Program {
	public static void main(String[] args) {
		Interpreter interpreter = Interpreter.fromFile(args[0]);
		interpreter.interpret();
	}
}
