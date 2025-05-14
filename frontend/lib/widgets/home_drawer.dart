import 'package:flutter/material.dart';
import 'package:frontend/pages/memo_list_view_page.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('MyndLy')),
          ListTile(
            title: const Text('メモ一覧'),
            leading: const Icon(Icons.inbox),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const MemoListViewPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
