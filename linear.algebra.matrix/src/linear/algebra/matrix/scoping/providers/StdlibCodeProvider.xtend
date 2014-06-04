package linear.algebra.matrix.scoping.providers

import linear.algebra.matrix.matrix.MatrixPackage
import linear.algebra.matrix.matrix.FuncDeclaration
import linear.algebra.matrix.matrix.ProcDeclaration

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.emf.common.util.URI

import com.google.inject.Inject
import com.google.inject.assistedinject.Assisted

class StdlibCodeProvider extends BuiltinCodeProvider {
	@Inject
	IResourceDescription.Manager descrManager

	private var Resource stdlibResource = null

	@Inject
	new(@Assisted ResourceSet resourceSet) {
		super(resourceSet)
	}

	override getFunctions() {
		super.getFunctions() + getStdlibFunctions()
	}

	override getProcs() {
		super.getProcs() + getStdlibProcs()
	}

	def protected getStdlibFunctions() {
		ensureLoaded()
		descrManager.getResourceDescription(stdlibResource).exportedObjects
			.filter [ obj | MatrixPackage.eINSTANCE.funcDeclaration.isSuperTypeOf(obj.EClass) ]
			.map [ descr |
				new Function(descr.qualifiedName, InterpretationMethod.Interpreter, descr.EObjectOrProxy as FuncDeclaration)
			]
	}

	def protected getStdlibProcs() {
		ensureLoaded()
		descrManager.getResourceDescription(stdlibResource).exportedObjects
			.filter [ obj | MatrixPackage.eINSTANCE.procDeclaration.isSuperTypeOf(obj.EClass) ]
			.map [ descr |
				new Proc(descr.qualifiedName, InterpretationMethod.Interpreter, descr.EObjectOrProxy as ProcDeclaration)
			]
	}

	def private void ensureLoaded() {
		if (stdlibResource == null)
			stdlibResource = loadStdlib()
	}

	def protected String stdlibSymbol() { // subclass hook to change filename
		'stdlib'
	}

	def protected stdlibURI() { // subclass hook to change URI
		val uri =  resourceSet.resources.get(0).URI // TODO: find a cleaner approach / a fixed stdlib location
		val segments = uri.segments.clone
		segments.set(segments.length - 1, stdlibSymbol() + ".mtx")
		URI.createHierarchicalURI(uri.scheme, uri.authority, uri.device, segments, null, null)
	}

	def protected Resource loadStdlib() { // subclass hook for different loading
		resourceSet.getResource(stdlibURI(), true)
	}
}