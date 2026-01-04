import 'package:flutter/material.dart';
import 'package:pawpal_project_301310/class/user.dart';

class Donationscreen extends StatefulWidget {
  final User? user;
  const Donationscreen({super.key, required this.user});

  @override
  State<Donationscreen> createState() => _DonationscreenState();
}

class _DonationscreenState extends State<Donationscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donation Screen')),
      body: const Center(),
    );
  }
}
