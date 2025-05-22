import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';

class MemoRawView extends StatelessWidget {
  const MemoRawView({required this.memo, super.key});

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(memo.raw),
    );
  }
}
