import 'package:flutter/material.dart';

class ErrorWithRefresh extends StatelessWidget {
  const ErrorWithRefresh({
    required this.onRefresh,
    this.errorMessage = 'エラーが発生しました。やり直してください',
    this.isRow = false,
    super.key,
  });

  final VoidCallback onRefresh;
  final String errorMessage;
  final bool isRow;

  @override
  Widget build(BuildContext context) {
    final children = [
      Text(errorMessage),
      ElevatedButton(onPressed: onRefresh, child: const Text('再読み込み')),
    ];

    return isRow
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: children,
        )
        : Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: children,
        );
  }
}
