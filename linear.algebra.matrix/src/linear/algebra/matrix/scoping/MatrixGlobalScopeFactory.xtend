package linear.algebra.matrix.scoping

import org.eclipse.emf.ecore.EClass
import linear.algebra.matrix.imports.ImportManager

interface MatrixGlobalScopeFactory {
	def MatrixGlobalScope create(EClass type, ImportManager origin)
}