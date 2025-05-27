import 'package:flutter/material.dart';

class ErrorWithRefresh extends StatelessWidget {
  const ErrorWithRefresh({
    required this.onRefresh,
    this.errorMessage = 'エラーが発生しました。やり直してください',
    super.key,
  });

  final VoidCallback onRefresh;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(errorMessage),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onRefresh, child: const Text('再読み込み')),
      ],
    );
  }
}
