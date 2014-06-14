package linear.algebra.matrix.interpreter.repl;

import com.google.inject.Injector;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceFactoryImpl;

public class Program {
	public static void main(String[] args) {
		Injector injector = new MatrixREPLSetup().createInjectorAndDoEMFRegistration();
		Resource.Factory.Registry.INSTANCE.getProtocolToFactoryMap().put(REPL.RESOURCE_URI, new ResourceFactoryImpl());

		REPL repl = injector.getInstance(REPL.class);
		System.out.println("linear.algebra.matrix REPL");
		System.out.println("==========================");
		System.out.println("Enter code below.");
		repl.start(System.in, System.out, System.err);
	}

	protected static String appPath() {
		// http://stackoverflow.com/questions/218061/get-the-applications-path/676413#676413
		return Program.class.getProtectionDomain().getCodeSource().getLocation().getPath();
	}
}
