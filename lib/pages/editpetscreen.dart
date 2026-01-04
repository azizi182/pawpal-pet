import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/pet.dart';

class Editpetscreen extends StatefulWidget {
  final petDetails? mypet;
  const Editpetscreen({super.key, required this.mypet});

  @override
  State<Editpetscreen> createState() => _EditpetscreenState();
}

class _EditpetscreenState extends State<Editpetscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pet Screen')),
      body: const Center(),
    );
  }
}
