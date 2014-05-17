package linear.algebra.matrix.core;

public abstract class Matrix<T> {
	private int height;
	private int width;

	protected Matrix(int height, int width) {
		setHeight(height);
		setWidth(width);
	}

	private void setHeight(int height) {
		if (height <= 0)
			throw new IllegalArgumentException("Matrix height must be > 0");
		this.height = height;
	}

	public int getHeight() {
		return height;
	}

	private void setWidth(int width) {
		if (width <= 0)
			throw new IllegalArgumentException("Matrix width must be > 0");
		this.width = width;
	}

	public int getWidth() {
		return width;
	}

	private void checkIndices(int i, int j) {
		if (i <= 0 || i > height || j <= 0 || j > width)
			throw new IllegalArgumentException("Indices must be > 0 and less than matrix height and width respectively");
	}

	public T getEntry(int i, int j) {
		checkIndices(i, j);
		return getEntries()[i-1][j-1];
	}

	public void setEntry(int i, int j, T entry) {
		checkIndices(i, j);
		getEntries()[i-1][j-1] = entry;
	}

	protected abstract T[][] getEntries(); // dimensions must be height and width

	@Override
	public String toString() {
		T[][] entries = getEntries();
		String str = "";
		for (int i = 0; i < height; ++i) {
			for (int j = 0; j < width; ++j)
				str = str + entries[i][j] + " ";
			str = str.trim() + "\n";
		}
		return str.trim();
	}

	@Override
	public boolean equals(Object o) {
		if (!(o instanceof Matrix))
			return false;
		Matrix other = (Matrix)o;
		if (width != other.width || height != other.height)
			return false; // only matrices of same dimensions can be equal
		for (int i = 1; i <= height; ++i)
			for (int j = 1; j <= width; ++j)
				if (!getEntry(i, j).equals(other.getEntry(i, j))) // compare entry by entry (do not use getEntries().equals() because it falls back on Object.equals())
					return false;
		return true;
	}

	@Override
	public int hashCode() {
		int hash = width + height;
		for (int i = 1; i <= height; ++i)
			for (int j = 1; j <= width; ++j)
				hash += getEntry(i, j).hashCode();
		return hash;
	}
}
