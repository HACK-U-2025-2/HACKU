import 'package:flutter/material.dart';
import 'package:frontend/widgets/home_drawer.dart';
import 'package:frontend/widgets/memo_card.dart';
import 'package:frontend/widgets/memo_text_field.dart';
import 'package:frontend/widgets/record_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // キーボードが開くとき、スクロールしないようにする。
      // これにより、Overflowが発生しないようにする。
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('ホーム'), centerTitle: true),
      drawer: const HomeDrawer(),
      body: GestureDetector(
        onTap: () {
          // タップ検知可能なWidget以外をタップしたとき、キーボードを閉じる
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: const SafeArea(
          child: Column(
            spacing: 8,
            children: [
              Padding(padding: EdgeInsets.all(16), child: MemoTextField()),
              Divider(),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('頻出メモ'),
                ),
              ),
              Expanded(child: _MemoListView()),
              RecordButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemoListView extends StatelessWidget {
  const _MemoListView();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return const MemoCard();
      },
    );
  }
}
