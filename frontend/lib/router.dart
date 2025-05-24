import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true, path: Destination.home.path),
    AutoRoute(page: MemoListViewRoute.page, path: Destination.memoList.path),
    AutoRoute(page: MemoDetailsRoute.page),
  ];
}

enum Destination {
  home(iconData: Icons.home_outlined, label: 'ホーム', path: '/'),
  memoList(iconData: Icons.list_outlined, label: 'メモ一覧', path: '/memo-list')
  // tagList(iconData: Icons.label_outline, label: 'タグ一覧'),
  // importantList(iconData: Icons.favorite_outline, label: '重要メモ'),
  // archiveList(iconData: Icons.archive_outlined, label: 'アーカイブ')
  ;

  const Destination({
    required this.iconData,
    required this.label,
    required this.path,
  });

  final IconData iconData;
  final String label;
  final String path;
}

extension DestinationX on RouteData {
  Destination? toDestination() {
    for (final dest in Destination.values) {
      if (dest.path == path) {
        return dest;
      }
    }
    return null;
  }
}
