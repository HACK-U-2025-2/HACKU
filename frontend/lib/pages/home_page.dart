import 'package:flutter/material.dart';
import 'package:frontend/widgets/home_drawer.dart';
import 'package:frontend/widgets/memo_text_field.dart';
import 'package:frontend/widgets/mini_memo_card.dart';
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
            children: [
              _MemoListHeaderLabel(),
              SizedBox(height: 8),
              SizedBox(height: 60, child: _MemoHorizontalListView()),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: MemoTextField(),
                ),
              ),
              RecordButton(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemoListHeaderLabel extends StatelessWidget {
  const _MemoListHeaderLabel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('頻出メモ', style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

class _MemoHorizontalListView extends StatelessWidget {
  const _MemoHorizontalListView();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(width: 4),
      itemBuilder: (context, index) {
        return const MiniMemoCard();
      },
    );
  }
}
