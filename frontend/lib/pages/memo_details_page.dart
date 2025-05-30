import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/pages/errors/memo_error_with_refresh_page.dart';
import 'package:frontend/pages/errors/memo_not_found_page.dart';
import 'package:frontend/providers/memo_edit_provider.dart';
import 'package:frontend/providers/memo_provider.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/widgets/custom_back_button.dart';
import 'package:frontend/widgets/dialogs/input_dialog.dart';
import 'package:frontend/widgets/favorite_button.dart';
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
  const MemoDetailsPage({required this.memoId, super.key});

  final MemoId memoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoValue = ref.watch(memoProvider(memoId));

    if (memoValue.isLoading && !memoValue.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (memoValue.hasError) {
      final error = memoValue.error;
      debugPrint('memoAsyncValue error: $error');
      return switch (error) {
        final MemoNotFoundException _ => const MemoNotFoundPage(),
        _ => MemoErrorWithRefreshPage(memoId: memoId),
      };
    }

    final memo = memoValue.requireValue;
    final tags = ref.watch(memoTagNamesProvider);

    final currentTab = useState(MemoDetailsTab.body);
    final tabController = useTabController(
      initialLength: MemoDetailsTab.values.length,
    );

    void updateCurrentTab() {
      currentTab.value = MemoDetailsTab.values[tabController.index];
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(memoTagNamesProvider.notifier).setTags(memo.tags);
      });
      return null;
    }, [memo]);

    useEffect(() {
      tabController.addListener(updateCurrentTab);
      return () {
        tabController.removeListener(updateCurrentTab);
      };
    }, [tabController]);

    final isEditingMode = ref.watch(isEditingModeProvider);
    final showFab = !isEditingMode && currentTab.value == MemoDetailsTab.body;

    return Scaffold(
      appBar: AppBar(
        title: MemoTitleMenu(memo: memo),
        actions: [
          FavoriteButton(
            memoId: memo.id,
            isFavorite: memo.isFavorite,
            afterToggle: () {
              ref.invalidate(memoProvider(memoId));
            },
          ),
        ],
        leading: const CustomBackButton(),
      ),
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
            _TagsHorizontalListView(tagNames: tags),
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

class _TagsHorizontalListView extends ConsumerWidget {
  const _TagsHorizontalListView({required this.tagNames});

  final List<String> tagNames;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditingMode = ref.watch(isEditingModeProvider);
    // 編集モードなら、タグの数 + 追加ボタンの1
    final itemCount = tagNames.length + (isEditingMode ? 1 : 0);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          // 編集モードで、かつ最後のアイテムの場合に追加ボタンを表示
          final isAddButtonIndex = isEditingMode && index == tagNames.length;

          if (isAddButtonIndex) {
            return const _AddTagButton();
          }
          // 通常のタグ表示
          final tagName = tagNames[index];
          return _TagChip(tagName: tagName);
        },
      ),
    );
  }
}

class _AddTagButton extends ConsumerWidget {
  const _AddTagButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagNames = ref.watch(memoTagNamesProvider);
    return GestureDetector(
      child: const Icon(Icons.add),
      onTap: () async {
        final newTagName = await showDialog<String>(
          context: context,
          builder: (context) {
            return AddMemoTagInputDialog(existingTagNames: tagNames);
          },
        );
        if (newTagName != null) {
          ref.read(memoTagNamesProvider.notifier).addTag(newTagName);
        }
      },
    );
  }
}

class _TagChip extends ConsumerWidget {
  const _TagChip({required this.tagName});

  final String tagName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditingMode = ref.watch(isEditingModeProvider);

    return Chip(
      label: Text(tagName),
      deleteIcon: const Icon(Icons.close),
      onDeleted:
          isEditingMode
              ? () {
                // TODO(tyPhoon-collab): Websocketに対応時にダイアログを表示する機構を復活させる
                ref.read(memoTagNamesProvider.notifier).removeTag(tagName);
              }
              : null,
    );
  }
}
