import 'package:flutter/material.dart';
import 'package:frontend/pages/memo_list_view_page.dart';

enum HomeDrawerDestination {
  home(iconData: Icons.home_outlined, label: 'ホーム'),
  memoList(iconData: Icons.list_outlined, label: 'メモ一覧'),
  tagList(iconData: Icons.label_outline, label: 'タグ一覧'),
  important(iconData: Icons.favorite_outline, label: '重要メモ'),
  archive(iconData: Icons.archive_outlined, label: 'アーカイブ');

  const HomeDrawerDestination({required this.iconData, required this.label});

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
        for (final destination in HomeDrawerDestination.values)
          NavigationDrawerDestination(
            icon: Icon(destination.iconData),
            label: Text(destination.label),
          ),
      ],
      onDestinationSelected: (value) {
        final destination = HomeDrawerDestination.values[value];
        switch (destination) {
          case HomeDrawerDestination.home:
            Navigator.of(context).pop();
          case HomeDrawerDestination.memoList:
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const MemoListViewPage(),
              ),
            );
          case HomeDrawerDestination.tagList:
          case HomeDrawerDestination.important:
          case HomeDrawerDestination.archive:
            throw UnimplementedError('未実装のメニューが選択されました: ${destination.label}');
        }
      },
    );
  }
}
