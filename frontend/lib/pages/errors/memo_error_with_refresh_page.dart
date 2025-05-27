import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/providers/memo_provider.dart';
import 'package:frontend/widgets/error_with_refresh.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoErrorWithRefreshPage extends ConsumerWidget {
  const MemoErrorWithRefreshPage({required this.memoId, super.key});

  final MemoId memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('エラー')),
      body: Center(
        child: ErrorWithRefresh(
          onRefresh: () {
            ref.invalidate(memoProvider(memoId));
          },
        ),
      ),
    );
  }
}
