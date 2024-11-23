import 'package:flutter/material.dart';

class NetworkStatusScreen extends StatelessWidget {
  const NetworkStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('netowrk status'),
      ),
      body: const Center(child: Text("No internet")),
    );
  }
}
