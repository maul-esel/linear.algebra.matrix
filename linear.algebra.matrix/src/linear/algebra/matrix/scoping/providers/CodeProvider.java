package linear.algebra.matrix.scoping.providers;

import org.eclipse.emf.ecore.resource.ResourceSet;

public interface CodeProvider {
	ResourceSet getResourceSet();

	Function[] getFunctions();
	Proc[] getProcs();

	Object interpretFunction(Function func, Object[] parameters);
	void interpretProc(Proc proc, Object[] parameters);

	// no variables for now
}
