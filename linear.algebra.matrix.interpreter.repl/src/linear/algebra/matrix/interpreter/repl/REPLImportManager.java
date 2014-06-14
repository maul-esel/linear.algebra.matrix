package linear.algebra.matrix.interpreter.repl;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;

import linear.algebra.matrix.imports.ImportManagerImpl;

import com.google.inject.Inject;
import com.google.inject.assistedinject.Assisted;

public class REPLImportManager extends ImportManagerImpl {
	@Inject
	public REPLImportManager(@Assisted Resource resource) {
		super(resource);
	}

	@Override
	protected URI importURI(String name) {
		return URI.createURI(Program.appPath() + "../../linear.algebra.matrix.examples/src/" + name + ".mtx", true); // TODO
	}
}
