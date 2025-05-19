import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      padding: const EdgeInsets.all(24),
      onPressed: () {},
      icon: const Icon(Icons.mic, size: 80),
    );
  }
}
