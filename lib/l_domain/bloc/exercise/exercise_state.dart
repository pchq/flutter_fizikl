part of 'exercise_cubit.dart';

@immutable
abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseSuccess extends ExerciseState {
  final List<Exercise> exercises;
  ExerciseSuccess({
    required this.exercises,
  });
}

class ExerciseError extends ExerciseState {
  final String message;
  ExerciseError({
    required this.message,
  });
}
