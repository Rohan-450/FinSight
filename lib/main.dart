//import 'package:finsight/screens/login_screen.dart';
import 'package:finsight/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinSight',
      theme: ThemeData.dark(
        //colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 46, 1, 128)),
        useMaterial3: true,
      ),
      home: const RegisterScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}