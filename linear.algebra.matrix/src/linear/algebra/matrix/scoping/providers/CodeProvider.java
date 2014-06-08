package linear.algebra.matrix.scoping.providers;

import org.eclipse.emf.ecore.resource.Resource;

public interface CodeProvider {
	Function[] getFunctionsFor(Resource resource);
	Proc[] getProcsFor(Resource resource);

	Object interpretFunction(Resource resource, Function func, Object[] parameters);
	void interpretProc(Resource resource, Proc proc, Object[] parameters);

	// no variables for now
}
