import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () async {
              // TotalDb incomeDb = TotalDb();
              // print(incomeDb.getAllTotals());
            }, 
            child: const Text('test')
          ),
        ),
      ),
    );
  }
}

