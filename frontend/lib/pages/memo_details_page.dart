import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/memo_edit_provider.dart';
import 'package:frontend/providers/memo_provider.dart';
import 'package:frontend/widgets/memo_details/memo_body_view.dart';
import 'package:frontend/widgets/memo_details/memo_raw_view.dart';
import 'package:frontend/widgets/memo_details/memo_title_menu.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum MemoDetailsTab {
  body(label: '要約'),
  raw(label: '原文');

  const MemoDetailsTab({required this.label});
  final String label;
}

@RoutePage()
class MemoDetailsPage extends HookConsumerWidget {
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

    final currentTab = useState(MemoDetailsTab.body);
    final tabController = useTabController(
      initialLength: MemoDetailsTab.values.length,
    );

    useEffect(() {
      tabController.addListener(() {
        currentTab.value = MemoDetailsTab.values[tabController.index];
      });
      return tabController.dispose;
    }, [tabController]);

    final isEditingMode = ref.watch(isEditingModeProvider);
    final showFab = !isEditingMode && currentTab.value == MemoDetailsTab.body;

    return Scaffold(
      appBar: AppBar(title: MemoTitleMenu(memo: memo)),
      floatingActionButton:
          showFab
              ? FloatingActionButton(
                onPressed: ref.read(isEditingModeProvider.notifier).toggle,
                child: const Icon(Icons.edit),
              )
              : null,
      body: SafeArea(
        child: Column(
          spacing: 8,
          children: [
            const SizedBox(height: 8),
            _TagsHorizontalListView(tags: memo.tags),
            TabBar(
              controller: tabController,
              tabs: [
                for (final tab in MemoDetailsTab.values) Tab(text: tab.label),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  for (final tab in MemoDetailsTab.values)
                    switch (tab) {
                      MemoDetailsTab.body => MemoBodyView(memo: memo),
                      MemoDetailsTab.raw => MemoRawView(memo: memo),
                    },
                ],
              ),
            ),
          ],
        ),
      ),
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
