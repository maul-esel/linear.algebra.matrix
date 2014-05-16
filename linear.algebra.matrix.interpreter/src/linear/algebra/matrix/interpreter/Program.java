package linear.algebra.matrix.interpreter;

import linear.algebra.matrix.MatrixStandaloneSetup;

import com.google.inject.Injector;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;

public class Program {
	public static void main(String[] args) {
		Injector injector = new MatrixStandaloneSetup().createInjectorAndDoEMFRegistration();

		ResourceSet rs = new ResourceSetImpl();
		Resource resource = rs.getResource(URI.createURI(args[0]), true);

		Interpreter interpreter = injector.getInstance(InterpreterFactory.class).create(resource);
		interpreter.interpret();
	}
}
