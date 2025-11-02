import 'package:flutter/material.dart';

class TestFabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test FAB')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.pets, size: 28),
      ),
      body: const Center(child: Text('Testseite für FloatingActionButton')),
    );
  }
}

