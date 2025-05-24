import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum SortMode {
  createdAt(label: '作成日時'),
  updatedAt(label: '更新日時');

  const SortMode({required this.label});

  final String label;
}

class SortOption {
  SortOption({required this.mode, required this.isAsc});

  final bool isAsc;
  final SortMode mode;

  String get query {
    switch (mode) {
      case SortMode.createdAt:
        return isAsc ? 'created_at_asc' : 'created_at_desc';
      case SortMode.updatedAt:
        return isAsc ? 'updated_at_asc' : 'updated_at_desc';
    }
  }
}

class SortDialog extends HookWidget {
  const SortDialog({
    required this.initialSortMode,
    required this.initialIsAsc,
    super.key,
  });

  final SortMode initialSortMode;
  final bool initialIsAsc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sortMode = useState(initialSortMode);
    final isAsc = useState(initialIsAsc);

    return AlertDialog(
      title: const Text('メモの並び替え'),
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
          ...SortMode.values.map(
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
            ).pop(SortOption(mode: sortMode.value, isAsc: isAsc.value));
          },
          child: const Text('並び替え'),
        ),
      ],
    );
  }
}
