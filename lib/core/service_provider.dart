import 'package:get_it/get_it.dart';
import 'package:fizikl/l_data/datasources/fake_datasource.dart';
import 'package:fizikl/l_data/datasources/i_datasource.dart';
import 'package:fizikl/l_data/repositories/execise_repository.dart';
import 'package:fizikl/l_domain/bloc/exercise/exercise_cubit.dart';
import 'package:fizikl/l_domain/repositories/i_execise_repository.dart';

/// Service Locator
class ServiceProvider {
  static final _getIt = GetIt.I;

  T get<T extends Object>() => _getIt.get<T>();

  static final I = ServiceProvider();

  void init() {
    /// BLoC
    _getIt.registerLazySingleton<ExerciseCubit>(
      () => ExerciseCubit(repository: _getIt()),
    );

    /// Repository
    _getIt.registerLazySingleton<IExerciseRepository>(
      () => ExerciseRepository(datasource: _getIt()),
    );

    /// Datasource
    _getIt.registerLazySingleton<IDatasource>(
      () => FakeDatasource(),
    );
  }
}
