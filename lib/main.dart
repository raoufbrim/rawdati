import 'package:assil_app/splash_screen/onboarding.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assil app',
      theme: ThemeData(primaryColor: const Color(0xFF40B7D5)),
      home: onboard(),
    );
  }
}
