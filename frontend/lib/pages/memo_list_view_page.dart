import 'package:flutter/material.dart';
import 'package:frontend/pages/memo_details_page.dart';
import 'package:frontend/widgets/home_drawer.dart';
import 'package:frontend/widgets/memo_card.dart';

class MemoListViewPage extends StatelessWidget {
  const MemoListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DestinationNavigationDrawer(),
      appBar: AppBar(title: const Text('メモ一覧')),
      body: ListView(
        children: [
          MemoCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const MemoDetailsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
