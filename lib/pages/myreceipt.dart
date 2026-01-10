import 'package:flutter/material.dart';

class Myreceipt extends StatefulWidget {
  const Myreceipt({super.key});

  @override
  State<Myreceipt> createState() => _MyreceiptState();
}

class _MyreceiptState extends State<Myreceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Receipt')),
      body: const Center(child: Text('This is the My Receipt page.')),
    );
  }
}
