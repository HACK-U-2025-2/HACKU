import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class MemoNotFoundPage extends StatelessWidget {
  const MemoNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('エラー')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Myndが見つかりません'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: context.router.pop,
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
