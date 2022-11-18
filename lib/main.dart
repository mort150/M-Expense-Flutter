import 'package:assignment/database/database.dart';
import 'package:assignment/database/dbhelper.dart';
import 'package:assignment/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(db: await DatabaseHelper().build()));
}

class MyApp extends StatelessWidget {
  AppDB db;

  MyApp({super.key, required this.db});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Expense ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(db: db),
    );
  }
}
