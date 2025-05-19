import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/widgets/destination_navigation_drawer.dart';
import 'package:frontend/widgets/memo_card.dart';

class MemoListViewPage extends StatelessWidget {
  const MemoListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockMemoList = List.generate(
      20,
      (index) => MemoPreview(
        id: MemoId(index),
        title: 'メモタイトル$index',
        body: 'だんだん長くなるメモの要約。' * (index + 1),
        createdAt: DateTime.now(),
      ),
    );

    return Scaffold(
      drawer: const DestinationNavigationDrawer(),
      appBar: AppBar(title: const Text('メモ一覧')),
      body: ListView(
        children: [
          ...mockMemoList.map(
            (memoPreview) => MemoCard(memoPreview: memoPreview),
          ),
        ],
      ),
    );
  }
}
