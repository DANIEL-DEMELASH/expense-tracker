import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_task/data/data_sources/local/expense_db.dart';
import 'package:interview_task/data/data_sources/local/income_db.dart';
import 'package:interview_task/data/data_sources/local/total_db.dart';
import 'package:interview_task/data/models/expense.dart';
import 'package:interview_task/data/models/income.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_bloc.dart';
import 'package:interview_task/presentation/bloc/local_db_bloc/local_event.dart';
import 'package:interview_task/presentation/bloc/remote_bloc/remote_bloc.dart';
import 'package:interview_task/presentation/bloc/remote_bloc/remote_event.dart';
import 'package:interview_task/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: MultiProvider(
        providers: [
          BlocProvider(
            create: (context) => LocalBloc()..add(GetTotalList()),
          ),
          BlocProvider(
            create: (context) => RemoteBloc()..add(GetCurrency()),
          ),
        ],
        child:const HomePage(),
      ),
    );
  }
}

