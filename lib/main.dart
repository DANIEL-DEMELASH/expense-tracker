import 'package:flutter/material.dart';
import 'package:interview_task/presentation/pages/home_page.dart';
import 'package:interview_task/presentation/provider/local_provider/local_provider.dart';
import 'package:interview_task/presentation/provider/remote_provider/remote_provider.dart';
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
          ChangeNotifierProvider(create: (context) => LocalProvider()..getTotalList()),
          ChangeNotifierProvider(create: (context) => RemoteProvider()..getCurrency())
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage()),
        ),
    );
  }
}
