package linear.algebra.matrix.interpreter;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

public class VariableRegister {
	private final static VariableRegister empty = new VariableRegister();

	private final static Object undefined = new Object();

	private VariableRegister superScope = empty; // { != null, except for empty itself }

	private final HashMap<String, Object> variables = new HashMap<String, Object>();

	private final HashSet<String> constants = new HashSet<String>();

	public VariableRegister(VariableRegister superScope) {
		setSuperScope(superScope);
	}

	public VariableRegister() { }

	private void setSuperScope(VariableRegister superScope) {
		if (superScope == null)
			throw new IllegalArgumentException("superScope must not be null");
		this.superScope = superScope;
	}

	public void add(String name) {
		if (existsLocally(name))
			throw new IllegalStateException("Variable " + name + " already exists");
		variables.put(name, undefined);
	}

	public void add(String name, Object value) {
		add(name);
		set(name, value);
	}

	public void add(String name, Object value, boolean constant) {
		add(name, value);
		if (constant)
			makeConstant(name);
	}

	public Object get(String name) {
		if (!exists(name))
			throw new IllegalStateException("Variable " + name + " does not exist");
		if (!isDefined(name))
			throw new IllegalStateException("Variable " + name + " does not yet have a defined value");

		if (existsLocally(name))
			return variables.get(name);
		else
			return superScope.get(name);
	}

	public void set(String name, Object value) {
		if (!exists(name))
			throw new IllegalStateException("Variable " + name + " does not exist");
		if (isConstant(name))
			throw new IllegalStateException("Variable " + name + " is constant and cannot be set");

		if (existsLocally(name))
			variables.put(name,  value);
		else
			superScope.set(name, value);
	}

	public boolean exists(String name) {
		return existsLocally(name) || (superScope != null && superScope.exists(name));
	}

	private boolean existsLocally(String name) {
		return variables.containsKey(name);
	}

	public boolean isDefined(String name) {
		return existsLocally(name) ? !undefined.equals(variables.get(name)) : (superScope != null && superScope.isDefined(name));
	}

	public boolean isConstant(String name) {
		return existsLocally(name) ? constants.contains(name) : (superScope != null && superScope.isConstant(name));
	}

	public void makeConstant(String name) {
		if (!isDefined(name))
			throw new IllegalStateException("Variable " + name + " is not yet defined and thus can't be made constant");

		if (existsLocally(name))
			constants.add(name);
		else
			superScope.makeConstant(name);
	}

	public Set<String> getVariables() {
		return variables.keySet();
	}
}
