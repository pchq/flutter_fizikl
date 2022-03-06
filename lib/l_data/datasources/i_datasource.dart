import 'package:fizikl/model/exercise.dart';

/// интерфейс источника данных
abstract class IDatasource {
  /// получение списка всех упражнений
  Future<List<Exercise>> getExercises();

  /// сохранение списка упражнений
  Future<void> saveExercises(List<Exercise> list);
}
