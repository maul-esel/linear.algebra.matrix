package linear.algebra.matrix.core;

import java.util.Hashtable;
import java.util.HashSet;

public class VariableRegister {
	private static VariableRegister empty = new VariableRegister();

	private VariableRegister superScope = empty;

	private Object undefined = new Object();

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
		if (exists(name))
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
		return variables.get(name);
	}

	public void set(String name, Object value) {
		if (!exists(name))
			throw new IllegalStateException("Variable " + name + " does not exist");
		if (isConstant(name))
			throw new IllegalStateException("Variable " + name + " is constant and cannot be set");
		variables.put(name,  value);
	}

	public boolean exists(String name) {
		return variables.containsKey(name);
	}

	public boolean isDefined(String name) {
		return exists(name) && !undefined.equals(variables.get(name));
	}

	public boolean isConstant(String name) {
		return constants.contains(name);
	}

	public void makeConstant(String name) {
		if (!isDefined(name))
			throw new IllegalStateException("Variable " + name + " is not yet defined and thus can't be made constant");
		constants.add(name);
	}
}
