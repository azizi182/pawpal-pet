import 'package:flutter/material.dart';

class Submitpetscreen extends StatefulWidget {
  const Submitpetscreen({super.key});

  @override
  State<Submitpetscreen> createState() => _SubmitpetscreenState();
}

class _SubmitpetscreenState extends State<Submitpetscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Pet Screen')),

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            children: [
              TextField(decoration: InputDecoration(labelText: 'Pet Name')),

              SizedBox(height: 10.0),
              TextField(decoration: InputDecoration(labelText: 'Pet Age')),

              SizedBox(height: 10.0),
              TextField(decoration: InputDecoration(labelText: 'Pet Type')),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
