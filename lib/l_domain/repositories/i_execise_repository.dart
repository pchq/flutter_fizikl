import 'package:fizikl/model/exercise.dart';

/// интерфейс взаимодействия с упражнениями
abstract class IExerciseRepository {
  /// получение списка всех упражнений
  Future<List<Exercise>> getList();

  /// сохранение списка упражнений
  Future<void> saveList(List<Exercise> list);
}
