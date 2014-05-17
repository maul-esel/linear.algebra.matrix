package linear.algebra.matrix.validation

import linear.algebra.matrix.imports.ImportManagerFactory

import linear.algebra.matrix.matrix.Import
import linear.algebra.matrix.matrix.MatrixPackage

import linear.algebra.matrix.semantics.validation.ChecksValidator

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check

class MatrixValidator extends ChecksValidator {
	@Inject
	ImportManagerFactory importsFactory

	@Check
	def void cImportIsValid(Import imp) {
		val manager = importsFactory.create(imp.eResource)
		if (!manager.isValidImport(imp.source))
			error("Import is not valid", imp, MatrixPackage.eINSTANCE.import_Source)
	}
}
