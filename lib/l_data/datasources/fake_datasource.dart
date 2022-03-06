import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fizikl/l_data/datasources/i_datasource.dart';
import 'package:fizikl/model/exercise.dart';
import 'package:path_provider/path_provider.dart';

/// реализация тестового получения данных с сервера
class FakeDatasource implements IDatasource {
  /// файл с данными на устройстве
  Future<File> get _localDataFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  /// имитация ошибки
  /// вернет исключение с вероятностью 1/5
  void _randomFailure() {
    int r = Random().nextInt(5);
    if (r == 0) throw Exception('fake exception');
  }

  @override
  Future<List<Exercise>> getExercises() async {
    _randomFailure();

    final dataFile = await _localDataFile;
    String data;

    if (await dataFile.exists()) {
      data = await dataFile.readAsString();
    } else {
      data = _defaultData;
    }

    // пауза для имитации загрузки
    await Future.delayed(const Duration(milliseconds: 1500));
    List<Exercise> exercises =
        (json.decode(data) as List).map((e) => Exercise.fromJson(e)).toList();
    return exercises;
  }

  @override
  Future<void> saveExercises(List<Exercise> exercises) async {
    _randomFailure();

    final dataFile = await _localDataFile;
    dataFile.writeAsString(json.encode(exercises));
  }

  /// дефолные данные
  final String _defaultData = '''
    [
    {"id": 1, "order": 1, "order_prefix": ""},
    {"id": 2, "order": 2, "order_prefix": "a"},
    {"id": 3, "order": 2, "order_prefix": "b"},
    {"id": 4, "order": 2, "order_prefix": "c"},
    {"id": 5, "order": 3, "order_prefix": ""},
    {"id": 6, "order": 4, "order_prefix": ""}
]
    ''';
}
