package linear.algebra.matrix.scoping.providers

import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceImpl

import linear.algebra.matrix.matrix.Type
import linear.algebra.matrix.matrix.MathematicalType
import linear.algebra.matrix.matrix.MatrixFactory

import linear.algebra.matrix.core.Rational
import linear.algebra.matrix.core.Complex
import linear.algebra.matrix.core.Matrix

import linear.algebra.matrix.util.Cache

import java.util.Collections
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.util.HashMap

import java.lang.reflect.Method
import java.lang.reflect.ParameterizedType
import java.lang.reflect.WildcardType

import java.lang.annotation.Retention
import java.lang.annotation.Target
import java.lang.annotation.ElementType
import java.lang.annotation.RetentionPolicy

import org.eclipse.xtext.util.PolymorphicDispatcher
import org.eclipse.xtext.util.PolymorphicDispatcher.Predicates

import static extension linear.algebra.matrix.scoping.providers.IterableExtensions.*

public abstract class AbstractDeclarativeProvider implements CodeProvider {
	private val Map<Resource, Resource> providerResources = new HashMap<Resource, Resource>()
	private val functionCache = new Cache<Resource, Function[]>()
	private val procCache = new Cache<Resource, Proc[]>()

	override getFunctionsFor(Resource resource) {
		functionCache.get(resource, [ res | collectFunctions(res) ])
	}

	override getProcsFor(Resource resource) {
		procCache.get(resource, [ res | collectProcs(resource) ])
	}

	override interpretFunction(Resource resource, Function func, Object[] parameters) {
		val dispatcher = new PolymorphicDispatcher<Object>(
			Collections.singletonList(this),
			functionPredicate(func)
		)
		dispatcher.invoke(parameters)
	}

	override interpretProc(Resource resource, Proc proc, Object[] parameters) {
		val dispatcher = new PolymorphicDispatcher<Object>(
			Collections.singletonList(this),
			procPredicate(proc)
		)
		dispatcher.invoke(parameters)
	}

	def protected Function[] collectFunctions(Resource resource) {
		class.methods
			.filter [ name.startsWith("func_") ]
			.groupBy [ name ]
			.values
			.map [ list | commonFunction(list, getProviderResourceFor(resource)) ]
	}

	def protected Proc[] collectProcs(Resource resource) {
		class.methods
			.filter [ name.startsWith("proc_") ]
			.groupBy [ name ]
			.values
			.map [ list | commonProc(list, getProviderResourceFor(resource)) ]
	}

	def protected functionPredicate(Function func) {
		Predicates.forName("func_" + func.name.lastSegment, func.func.params.params.size)
	}

	def protected procPredicate(Proc proc) {
		Predicates.forName("proc_" + proc.name.lastSegment.substring(1), proc.proc.params.params.size)
	}

	def protected commonFunction(List<Method> methods, Resource providerResource) {
		if (methods.map [ parameterTypes.size ].size > 1)
			throw new IllegalStateException("Overloads must have same number of parameters: " + methods.last.name)

		val funcName   = QualifiedName.create(#[getNamespace(methods), methods.last.name.substring(5)].filterNull)
		val returnType = toLanguageType(methods.map [ returnType ].reduce [ a, b | commonSuperClass(a, b) ])

		// for each i, get the list of i-th params, compute their common type and translate it to a language type
		val params = (0..<methods.last.parameterTypes.size)
			.map [ i | toLanguageType(methods.map [ parameterTypes.get(i) ].reduce [ a, b | commonSuperClass(a, b) ]) ]

		Function.createSymbolic(providerResource, funcName, params, returnType)
	}

	def protected commonProc(List<Method> methods, Resource providerResource) {
		if (methods.map [ parameterTypes.size ].size > 1)
			throw new IllegalStateException("Overloads must have same number of parameters: " + methods.last.name)
		if (!methods.map [ returnType ].toSet.elementsEqual(#[Void.TYPE]))
			throw new IllegalStateException("Procs must have the return type 'void': " + methods.last.name)

		val funcName = QualifiedName.create(#[getNamespace(methods), "@" + methods.last.name.substring(5)].filterNull)

		// for each i, get the list of i-th params, compute their common type and translate it to a language type
		val params = (0..<methods.last.parameterTypes.size)
			.map [ i | toLanguageType(methods.map [ genericParameterTypes.get(i) ].reduce [ a, b | commonSuperClass(a as Class<?>, b as Class<?>) ]) ]

		Proc.createSymbolic(providerResource, funcName, params)
	}

	@Retention(RetentionPolicy.RUNTIME)
	@Target(ElementType.METHOD, ElementType.TYPE)
	static annotation Namespace {
		public String value
	}

	def protected String getNamespace(List<Method> methods) {
		val annotatedNamespaces = methods.map [
			getAnnotation(Namespace) ?: declaringClass.getAnnotation(Namespace)
		].filterNull.map [ value ]

		if (annotatedNamespaces.size > 1)
			throw new IllegalStateException("Ambiguous namespace annotations: " + methods.last.name)
		else if (annotatedNamespaces.size == 1)
			annotatedNamespaces.last
		else null
	}

	// http://stackoverflow.com/questions/21121439/common-supertype-of-java-classes/21122643#21122643
	def protected Class<?> commonSuperClass(Class<?> a, Class<?> b) {
		var s = a;
		while (!s.isAssignableFrom(b))
			s = s.getSuperclass()
		s
	}

	def protected Type toLanguageType(java.lang.reflect.Type type) {
		switch (type) {
			case Integer.TYPE : MatrixFactory.eINSTANCE.createIntegerType()
			case Rational     : MatrixFactory.eINSTANCE.createRationalType()
			case Double.TYPE  : MatrixFactory.eINSTANCE.createRealType()
			case Complex      : MatrixFactory.eINSTANCE.createComplexType()
			case Boolean.TYPE : MatrixFactory.eINSTANCE.createBooleanType()
			case Number       : createGenericType()
			ParameterizedType : createParametrizedType(type)
			case Matrix       : createMatrixType(type as Class<Matrix<?>>, Number)
			default           : throw new IllegalStateException("Unsupported parameter type: " + type)
		}
	}

	def protected createMatrixType(Class<Matrix<?>> type, Class<? extends Number> entryType) {
		val matr = MatrixFactory.eINSTANCE.createMatrixType()
		matr.height = "$n"
		matr.width  = "$m"
		matr.entryType = toLanguageType(entryType) as MathematicalType
		matr
	}

	def protected Type createParametrizedType(ParameterizedType type) {
		switch (actualType : type.rawType) {
			Class<Matrix<?>> case Matrix : switch(entryType : type.actualTypeArguments.get(0)) {
					Class<? extends Number> : createMatrixType(actualType, entryType)
					WildcardType : createMatrixType(actualType, Number)
					default : throw new UnsupportedOperationException()
				}
		}
	}

	def protected createGenericType() {
		val type = MatrixFactory.eINSTANCE.createGenericType()
		type.name = "%generic" + Math.random()
		type
	}

	def protected Resource getProviderResourceFor(Resource res) {
		if (!providerResources.containsKey(res))
			providerResources.put(res, new ResourceImpl())
		providerResources.get(res)
	}
}

public class IterableExtensions {
	def static <T,R> Map<R, List<T>> groupBy(Iterable<T> collection, (T)=>R groupBy) {
		val map = new HashMap<R, List<T>>()
		collection.forEach [ item |
			val key = groupBy.apply(item)
			if (!map.containsKey(key))
				map.put(key, new ArrayList<T>())
			map.get(key).add(item)
		]
		map
	}
}