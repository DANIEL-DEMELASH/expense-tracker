import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_bloc.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_event.dart';
import 'package:interview_task/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => LocalBloc()..add(GetTotalList()),
        child: const HomePage(),
      ),
    );
  }
}

