import 'package:flutter/material.dart';

class MemoDetailsPage extends StatelessWidget {
  const MemoDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('仮タイトル'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Placeholder(),
    );
  }
}
