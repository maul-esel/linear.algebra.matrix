package linear.algebra.matrix.interpreter;

import linear.algebra.matrix.MatrixStandaloneSetup;

import com.google.inject.Injector;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;

public class Program {
	public static void main(String[] args) {
		Injector injector = new MatrixStandaloneSetup().createInjectorAndDoEMFRegistration();

		ResourceSet rs = injector.getInstance(ResourceSet.class);
		Resource resource = rs.getResource(URI.createURI(args[0]), true);

		Interpreter interpreter = injector.getInstance(InterpreterFactory.class).create(resource);
		try {
			interpreter.interpret();
		} catch (InterpreterException e) {
			e.printLanguageStackTrace();
		} catch (MatrixException e) {
			e.printLanguageStackTrace();
		}
	}
}
