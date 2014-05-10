package linear.algebra.matrix.core;

import java.util.Hashtable;
import java.util.HashSet;

public class VariableRegister {
	private static VariableRegister empty = new VariableRegister();

	private static Object undefined = new Object();

	private VariableRegister superScope = empty;

	private Hashtable<String, Object> variables = new Hashtable<>();

	private HashSet<String> constants = new HashSet<>();

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
		return existsLocally(name) || superScope.exists(name);
	}

	private boolean existsLocally(String name) {
		return variables.containsKey(name);
	}

	public boolean isDefined(String name) {
		return existsLocally(name) ? !undefined.equals(variables.get(name)) : superScope.isDefined(name);
	}

	public boolean isConstant(String name) {
		return existsLocally(name) ? constants.contains(name) : superScope.isConstant(name);
	}

	public void makeConstant(String name) {
		if (!isDefined(name))
			throw new IllegalStateException("Variable " + name + " is not yet defined and thus can't be made constant");

		if (existsLocally(name))
			constants.add(name);
		else
			superScope.makeConstant(name);
	}
}
