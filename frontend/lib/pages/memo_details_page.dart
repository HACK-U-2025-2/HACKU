import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/memo_provider.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum MemoDetailsTab {
  body(label: '要約'),
  raw(label: '原文');

  const MemoDetailsTab({required this.label});
  final String label;
}

class MemoDetailsPage extends ConsumerWidget {
  const MemoDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoAsyncValue = ref.watch(memoProvider(const MemoId(1)));

    if (memoAsyncValue.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (memoAsyncValue.hasError) {
      return const Scaffold(body: Center(child: Text('メモの取得に失敗しました')));
    }

    final memo = memoAsyncValue.requireValue;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(title: Text(memo.title)),
      body: DefaultTabController(
        length: MemoDetailsTab.values.length,
        child: SafeArea(
          child: Column(
            spacing: 8,
            children: [
              const SizedBox(height: 8),
              _TagsHorizontalListView(tags: memo.tags),
              TabBar(
                tabs: [
                  for (final tab in MemoDetailsTab.values) Tab(text: tab.label),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    for (final tab in MemoDetailsTab.values)
                      switch (tab) {
                        MemoDetailsTab.body => _MemoBodyView(memo: memo),
                        MemoDetailsTab.raw => _MemoRawView(memo: memo),
                      },
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemoBodyView extends StatelessWidget {
  const _MemoBodyView({required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GptMarkdown(memo.body),
    );
  }
}

class _MemoRawView extends StatelessWidget {
  const _MemoRawView({required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(memo.raw),
    );
  }
}

class _TagsHorizontalListView extends StatelessWidget {
  const _TagsHorizontalListView({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    // TODO(tyPhoon-collab): 編集モードの実装
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final tag = tags[index];
          return _TagChip(tag: tag);
        },
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tag.name),
      // onDeleted: () {
      //   // TODO(tyPhoon-collab): タグを削除する処理を実装する
      // },
    );
  }
}
