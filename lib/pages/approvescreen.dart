import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/user.dart';

class Approvescreen extends StatefulWidget {
  User? user;
  Approvescreen({super.key, required this.user});

  @override
  State<Approvescreen> createState() => _ApprovescreenState();
}

class _ApprovescreenState extends State<Approvescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve Screen')),
      body: const Center(),
    );
  }
}
