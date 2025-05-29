import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true, path: Destination.home.path),
    AutoRoute(page: MemoListViewRoute.page, path: Destination.memoList.path),
    AutoRoute(page: TagListViewRoute.page, path: Destination.tagList.path),
    AutoRoute(page: MemoDetailsRoute.page),
    AutoRoute(page: SphereRoute.page, path: Destination.sphere.path),
  ];
}

enum Destination {
  home(iconData: Icons.home_outlined, label: 'ホーム', path: '/'),
  memoList(iconData: Icons.list_outlined, label: 'メモ一覧', path: '/memo-list'),
  tagList(iconData: Icons.label_outline, label: 'タグ一覧', path: '/tag-list'),
  // importantList(iconData: Icons.favorite_outline, label: '重要メモ'),
  // archiveList(iconData: Icons.archive_outlined, label: 'アーカイブ'),
  sphere(iconData: Icons.public_outlined, label: '思考空間', path: '/sphere');

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
