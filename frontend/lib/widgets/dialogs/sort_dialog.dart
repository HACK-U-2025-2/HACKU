import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum MemoSortMode {
  createdAt(label: '作成日時'),
  updatedAt(label: '更新日時');

  const MemoSortMode({required this.label});

  final String label;
}

class MemoSortOption {
  MemoSortOption({required this.mode, required this.isAsc});

  final MemoSortMode mode;
  final bool isAsc;
}

class MemoSortDialog extends HookWidget {
  const MemoSortDialog({required this.initialSortOption, super.key});

  final MemoSortOption initialSortOption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sortMode = useState(initialSortOption.mode);
    final isAsc = useState(initialSortOption.isAsc);

    return AlertDialog(
      title: const Text('Myndの並び替え'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '基準',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ...MemoSortMode.values.map(
            (mode) => RadioListTile(
              value: mode,
              groupValue: sortMode.value,
              title: Text(mode.label),
              onChanged: (value) {
                if (value != null) {
                  sortMode.value = value;
                }
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '順序',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          RadioListTile(
            value: false,
            groupValue: isAsc.value,
            title: const Text('降順'),
            onChanged: (value) {
              if (value != null) {
                isAsc.value = value;
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile(
            value: true,
            groupValue: isAsc.value,
            title: const Text('昇順'),
            onChanged: (value) {
              if (value != null) {
                isAsc.value = value;
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop(MemoSortOption(mode: sortMode.value, isAsc: isAsc.value));
          },
          child: const Text('並び替え'),
        ),
      ],
    );
  }
}
