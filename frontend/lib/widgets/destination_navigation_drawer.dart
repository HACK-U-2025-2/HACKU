import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/router.dart';
import 'package:frontend/router.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DestinationNavigationDrawer extends ConsumerWidget {
  const DestinationNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final current = context.router.current.toDestination();

    if (current == null) {
      return const Center(child: Text('ルートが見つかりません'));
    }

    return NavigationDrawer(
      selectedIndex: current.index,
      onDestinationSelected: (value) {
        final destination = Destination.values[value];
        // Drawerを閉じる。popでも可能だが、明示的に閉じる
        Scaffold.of(context).closeDrawer();

        if (current == destination) return;

        // 入れ子にしないため、ホームまで戻る
        context.router.popUntilRoot();

        switch (destination) {
          case Destination.home:
            // 何もしない
            break;
          case Destination.memoList:
            context.router.push(const MemoListViewRoute());
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '瞬間メモ（仮）',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        for (final destination in Destination.values)
          NavigationDrawerDestination(
            icon: Icon(destination.iconData),
            label: Text(destination.label),
          ),
      ],
    );
  }
}
