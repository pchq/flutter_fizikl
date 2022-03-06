import 'package:fizikl/core/service_provider.dart';
import 'package:fizikl/l_domain/bloc/exercise/exercise_cubit.dart';
import 'package:fizikl/l_presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceProvider().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final ServiceProvider _serviceProvider = ServiceProvider();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _serviceProvider.get<ExerciseCubit>()..load(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
