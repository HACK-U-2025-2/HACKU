import 'package:flutter/material.dart';

enum Destination {
  home(iconData: Icons.home_outlined, label: 'ホーム'),
  memoList(iconData: Icons.list_outlined, label: 'メモ一覧')
  // tagList(iconData: Icons.label_outline, label: 'タグ一覧'),
  // importantList(iconData: Icons.favorite_outline, label: '重要メモ'),
  // archiveList(iconData: Icons.archive_outlined, label: 'アーカイブ')
  ;

  const Destination({required this.iconData, required this.label});

  final IconData iconData;
  final String label;
}
