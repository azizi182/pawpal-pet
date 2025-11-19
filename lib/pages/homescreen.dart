import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/user.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key, required this.user});
  final User? user;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(children: [Text('Welcome, ${widget.user?.userName} !')]),
      ),
    );
  }
}
