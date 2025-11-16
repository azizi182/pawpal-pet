import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/pages/loginscreen.dart';
import 'package:pawpal_project_301310/pages/splashpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Loginscreen());
  }
}
