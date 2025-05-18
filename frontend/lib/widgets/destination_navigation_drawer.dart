import 'package:flutter/material.dart';
import 'package:frontend/pages/memo_list_view_page.dart';
import 'package:frontend/providers/router_provider.dart';
import 'package:frontend/types/destination.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DestinationNavigationDrawer extends ConsumerWidget {
  const DestinationNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDestination = ref.watch(selectedDestinationProvider);
    final textTheme = Theme.of(context).textTheme;
    return NavigationDrawer(
      selectedIndex: selectedDestination.index,
      onDestinationSelected:
          (value) => _onDestinationSelected(ref, Destination.values[value]),
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

  void _onDestinationSelected(WidgetRef ref, Destination destination) {
    final context = ref.context;
    // Drawerを閉じる。popでも可能だが、明示的に閉じる
    Scaffold.of(context).closeDrawer();

    final selectedDestination = ref.read(selectedDestinationProvider);
    if (selectedDestination == destination) return;

    ref.read(selectedDestinationProvider.notifier).setDestination(destination);

    // ホームまで戻る
    // これをしないと、入れ子になってしまう
    Navigator.of(context).popUntil((route) => route.isFirst);

    switch (destination) {
      case Destination.home:
        // 何もしない
        break;
      case Destination.memoList:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const MemoListViewPage(),
          ),
        );
    }
  }
}
