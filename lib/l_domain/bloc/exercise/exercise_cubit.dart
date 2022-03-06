import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:fizikl/model/exercise.dart';

import 'package:fizikl/l_domain/repositories/i_execise_repository.dart';

part 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final IExerciseRepository repository;
  ExerciseCubit({
    required this.repository,
  }) : super(ExerciseInitial());

  /// загрузка списка упражнений
  void load() async {
    emit(ExerciseLoading());

    try {
      final data = await repository.getList();
      emit(ExerciseSuccess(exercises: data));
    } catch (e) {
      log('== error: $e');
      emit(ExerciseError(message: 'Ошибка при загрузке данных'));
    }
  }

  /// сохранение изменений списка
  void save(List<Exercise> exercises, int changedItem) async {
    emit(ExerciseLoading());

    try {
      final updatedList = _updateList(exercises, changedItem);
      await repository.saveList(updatedList);
      emit(ExerciseSuccess(exercises: updatedList));
    } catch (e) {
      log('== error: $e');
      emit(ExerciseError(message: 'Ошибка при сохранении данных'));
    }
  }

  /// обновление order-данных списка
  List<Exercise> _updateList(List<Exercise> exercises, int changedItem) {
    /// проверка на перенос упражнения в/из сета
    bool? inSet;
    // если элемент перенесли в начало списка
    if (changedItem == 0 && exercises[changedItem + 1].orderPrefix == '') {
      inSet = false;
      // если элемент перенесли в конец списка
    } else if (changedItem + 1 == exercises.length &&
        exercises[changedItem - 1].orderPrefix == '') {
      inSet = false;
      // если элемент оказался между сет-упражнениями
    } else if (((changedItem > 0 &&
            exercises[changedItem - 1].orderPrefix != '') &&
        (changedItem < exercises.length &&
            exercises[changedItem + 1].orderPrefix != ''))) {
      inSet = true;
      // если элемент оказался между НЕсет-упражнениями
    } else if (((changedItem > 0 &&
            exercises[changedItem - 1].orderPrefix == '') &&
        (changedItem < exercises.length &&
            exercises[changedItem + 1].orderPrefix == ''))) {
      inSet = false;
    }

    if (inSet != null) {
      exercises[changedItem] =
          exercises[changedItem].copyWith(orderPrefix: inSet ? '+' : '-');
    }

    Map<int, Exercise> exercisesMap = exercises.asMap();
    final List<Exercise> newList = [];

    /// счетчик количества упражнений и сетов для order
    int totalCounter = 0;

    /// счетчик количества упражнений в сете для order_prefix
    int setCounter = 0;
    exercisesMap.forEach((key, value) {
      Exercise updated;

      /// проверка на "упражнение в сете"
      if (!['', '-'].contains(value.orderPrefix) || value.orderPrefix == '+') {
        setCounter++;
        if (setCounter == 1) {
          totalCounter++;
        }
      } else {
        setCounter = 0;
        totalCounter++;
      }

      /// char code символа предшествующего "a",
      /// т.е. нумерация в сете начнется с startCharCode + 1 ("a")
      const int startCharCode = 96;
      updated = value.copyWith(
        orderPrefix: setCounter > 0
            ? String.fromCharCode(startCharCode + setCounter)
            : '',
        order: totalCounter,
      );

      newList.add(updated);
    });

    return newList;
  }
}
