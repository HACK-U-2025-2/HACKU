import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: const Text('この操作は取り消せません。'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('削除'),
        ),
      ],
    );
  }
}

class MemoDeleteDialog extends StatelessWidget {
  const MemoDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeleteDialog(title: 'このMyndを削除しますか？');
  }
}

class MemoTagDeleteDialog extends StatelessWidget {
  const MemoTagDeleteDialog({required this.tagName, super.key});

  final String tagName;

  @override
  Widget build(BuildContext context) {
    return DeleteDialog(title: 'タグ「$tagName」を削除しますか？');
  }
}
