import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

/// модель "упражнение"
@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    /// id
    required int id,

    /// сортировка 1-го уровня
    required int order,

    /// сортировка 2-го уровня
    @JsonKey(name: 'order_prefix') required String orderPrefix,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}
