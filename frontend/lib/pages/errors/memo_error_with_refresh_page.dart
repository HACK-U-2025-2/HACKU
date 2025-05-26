import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/providers/memo_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoErrorWithRefreshPage extends ConsumerWidget {
  const MemoErrorWithRefreshPage({required this.memoId, super.key});

  final MemoId memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('エラー')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('エラーが発生しました。やり直してください'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(memoProvider(memoId));
              },
              child: const Text('再読み込み'),
            ),
          ],
        ),
      ),
    );
  }
}
