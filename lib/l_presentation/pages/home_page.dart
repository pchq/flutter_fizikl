import 'package:fizikl/l_presentation/widgets/loader.dart';
import 'package:fizikl/model/exercise.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fizikl/l_domain/bloc/exercise/exercise_cubit.dart';
import 'package:fizikl/l_presentation/widgets/exercise_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Exercise> _exercises = [];

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.replay),
        onPressed: () {
          BlocProvider.of<ExerciseCubit>(context).load();
        },
      ),
      body: BlocConsumer<ExerciseCubit, ExerciseState>(
        listener: (context, state) {
          if (state is ExerciseError) {
            /// сообщение об ошибке
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ExerciseSuccess) {
            _exercises = state.exercises;
          }
          return state is ExerciseLoading
              ? const Loader()
              : ReorderableListView.builder(
                  itemBuilder: (_, index) => ExerciseCard(
                    _exercises[index],
                    key: Key('$index'),
                  ),
                  itemCount: _exercises.length,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final List<Exercise> changedExercises = _exercises.toList();
                    final Exercise item = changedExercises.removeAt(oldIndex);
                    changedExercises.insert(newIndex, item);

                    BlocProvider.of<ExerciseCubit>(context)
                        .save(changedExercises, newIndex);
                  },
                );
        },
      ),
    );
  }
}
