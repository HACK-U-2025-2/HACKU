import 'package:flutter/material.dart';
import 'package:frontend/pages/memo_list_view_page.dart';

enum _HomeDrawerDestination {
  home(iconData: Icons.home_outlined, label: 'ホーム'),
  memoList(iconData: Icons.list_outlined, label: 'メモ一覧'),
  tagList(iconData: Icons.label_outline, label: 'タグ一覧'),
  importantList(iconData: Icons.favorite_outline, label: '重要メモ'),
  archiveList(iconData: Icons.archive_outlined, label: 'アーカイブ');

  const _HomeDrawerDestination({required this.iconData, required this.label});

  final IconData iconData;
  final String label;
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return NavigationDrawer(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '瞬間メモ（仮）',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        for (final destination in _HomeDrawerDestination.values)
          NavigationDrawerDestination(
            icon: Icon(destination.iconData),
            label: Text(destination.label),
          ),
      ],
      onDestinationSelected: (value) {
        final destination = _HomeDrawerDestination.values[value];
        switch (destination) {
          case _HomeDrawerDestination.home:
            Navigator.of(context).pop();
          case _HomeDrawerDestination.memoList:
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const MemoListViewPage(),
              ),
            );
          case _HomeDrawerDestination.tagList:
          case _HomeDrawerDestination.importantList:
          case _HomeDrawerDestination.archiveList:
            // TODO: 各画面の実装
            showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(destination.label),
                  content: const Text('Coming soon...'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
        }
      },
    );
  }
}
