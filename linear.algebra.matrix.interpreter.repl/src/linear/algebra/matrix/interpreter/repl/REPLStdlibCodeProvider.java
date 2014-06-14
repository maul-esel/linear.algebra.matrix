package linear.algebra.matrix.interpreter.repl;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;

import linear.algebra.matrix.scoping.providers.StdlibCodeProvider;

public class REPLStdlibCodeProvider extends StdlibCodeProvider {
	@Override
	protected URI stdlibURI(Resource res) {
		return URI.createURI(Program.appPath() + "../../linear.algebra.matrix.examples/src/stdlib.mtx", true); // TODO
	}
}
