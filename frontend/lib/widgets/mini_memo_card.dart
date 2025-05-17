import 'package:flutter/material.dart';

class MiniMemoCard extends StatelessWidget {
  const MiniMemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'メモタイトル',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
