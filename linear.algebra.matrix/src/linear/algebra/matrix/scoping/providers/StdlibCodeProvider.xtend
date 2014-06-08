package linear.algebra.matrix.scoping.providers

import linear.algebra.matrix.matrix.MatrixPackage
import linear.algebra.matrix.matrix.FuncDeclaration
import linear.algebra.matrix.matrix.ProcDeclaration

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IResourceDescription
import org.eclipse.emf.common.util.URI

import java.util.Map
import java.util.Hashtable

import com.google.inject.Inject

class StdlibCodeProvider extends BuiltinCodeProvider {
	@Inject
	IResourceDescription.Manager descrManager

	private val Map<Resource, Resource> stdlibResources = new Hashtable<Resource, Resource>()

	override getFunctionsFor(Resource resource) {
		super.getFunctionsFor(resource) + getStdlibFunctions(load(resource))
	}

	override getProcsFor(Resource resource) {
		super.getProcsFor(resource) + getStdlibProcs(load(resource))
	}

	def protected getStdlibFunctions(Resource stdlibResource) {
		descrManager.getResourceDescription(stdlibResource).exportedObjects
			.filter [ obj | MatrixPackage.eINSTANCE.funcDeclaration.isSuperTypeOf(obj.EClass) ]
			.map [ descr |
				new Function(descr.qualifiedName, InterpretationMethod.Interpreter, descr.EObjectOrProxy as FuncDeclaration)
			]
	}

	def protected getStdlibProcs(Resource stdlibResource) {
		descrManager.getResourceDescription(stdlibResource).exportedObjects
			.filter [ obj | MatrixPackage.eINSTANCE.procDeclaration.isSuperTypeOf(obj.EClass) ]
			.map [ descr |
				new Proc(descr.qualifiedName, InterpretationMethod.Interpreter, descr.EObjectOrProxy as ProcDeclaration)
			]
	}

	def private load(Resource res) {
		if (!stdlibResources.containsKey(res))
			stdlibResources.put(res, loadStdlib(res))
		stdlibResources.get(res)
	}

	def protected String stdlibSymbol() { // subclass hook to change the filename
		'stdlib'
	}

	def protected stdlibURI(Resource res) { // subclass hook to change the URI
		// TODO: find a cleaner approach / a fixed stdlib location
		val segments = res.URI.segments.clone
		segments.set(segments.length - 1, stdlibSymbol() + ".mtx")
		URI.createHierarchicalURI(res.URI.scheme, res.URI.authority, res.URI.device, segments, null, null)
	}

	def protected Resource loadStdlib(Resource res) { // subclass hook for different loading
		res.resourceSet.getResource(stdlibURI(res), true)
	}
}