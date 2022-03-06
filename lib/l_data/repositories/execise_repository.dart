import 'package:fizikl/l_data/datasources/i_datasource.dart';
import 'package:fizikl/l_domain/repositories/i_execise_repository.dart';
import 'package:fizikl/model/exercise.dart';

class ExerciseRepository implements IExerciseRepository {
  final IDatasource datasource;
  ExerciseRepository({
    required this.datasource,
  });

  @override
  Future<List<Exercise>> getList() {
    return datasource.getExercises();
  }

  @override
  Future<void> saveList(List<Exercise> exercises) async {
    await datasource.saveExercises(exercises);
  }
}
