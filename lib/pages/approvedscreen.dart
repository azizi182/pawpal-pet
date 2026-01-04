import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/user.dart';

class Approvedscreen extends StatefulWidget {
  User? user;
  Approvedscreen({super.key, required this.user});

  @override
  State<Approvedscreen> createState() => _ApprovedscreenState();
}

class _ApprovedscreenState extends State<Approvedscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approved Screen')),
      body: const Center(),
    );
  }
}
