package linear.algebra.matrix.interpreter.repl;

import com.google.inject.Binder;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.assistedinject.FactoryModuleBuilder;

import linear.algebra.matrix.MatrixStandaloneSetup;

public class MatrixREPLSetup extends MatrixStandaloneSetup {
	@Override
	public Injector createInjector() {
		return Guice.createInjector(new linear.algebra.matrix.MatrixRuntimeModule() {
			@Override
			public Class<? extends linear.algebra.matrix.scoping.providers.CodeProvider> bindCodeProvider() {
				return REPLStdlibCodeProvider.class;
			}

			@Override
			protected void configureImportManagerFactory(Binder binder) {
				binder.install(new FactoryModuleBuilder()
					.implement(linear.algebra.matrix.imports.ImportManager.class,
							REPLImportManager.class)
					.build(linear.algebra.matrix.imports.ImportManagerFactory.class));
			}
		});
	}
}
