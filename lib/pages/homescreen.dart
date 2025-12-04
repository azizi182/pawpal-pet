import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/user.dart';
import 'package:pawpal_project_301310/pages/submitpetscreen.dart';

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
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // refresh data
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Submitpetscreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(children: [Text('Welcome, ${widget.user?.userName} !')]),
      ),
    );
  }
}
