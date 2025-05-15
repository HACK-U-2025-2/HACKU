import 'package:flutter/material.dart';

class MemoCard extends StatelessWidget {
  const MemoCard({super.key, this.onTap});

  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('仮タイトル', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              const Text('仮内容'),
            ],
          ),
        ),
      ),
    );
  }
}
