import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/widgets/destination_navigation_drawer.dart';
import 'package:frontend/widgets/dialogs/record_dialog.dart';
import 'package:frontend/widgets/memo_card.dart';

class MemoListViewPage extends HookWidget {
  const MemoListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchText = useState('');
    final debouncedSearchText = useDebounced(
      searchText.value,
      const Duration(milliseconds: 500),
    );
    useEffect(() {
      // TODO(Rozelin-dc): 検索処理, https://github.com/HACK-U-2025-2/HACKU/issues/75
      debugPrint('Search text: $debouncedSearchText');
      return null;
    }, [debouncedSearchText]);

    final mockMemoList = List.generate(
      20,
      (index) => MemoPreview(
        id: MemoId(index),
        title: 'メモタイトル$index',
        body: 'だんだん長くなるメモの要約。' * (index + 1),
        createdAt: DateTime.now(),
      ),
    );
    final mockTagList = List.generate(
      20,
      (index) => Tag(id: TagId(index), name: 'タグ$index'),
    );

    return Scaffold(
      drawer: const DestinationNavigationDrawer(),
      appBar: AppBar(title: const Text('メモ一覧')),
      floatingActionButton: const _AddMemoFab(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            spacing: 20,
            children: [
              _TagsHorizontalListView(tags: mockTagList),
              SearchBar(
                leading: const Icon(Icons.search),
                hintText: '検索キーワードを入力',
                onChanged: (value) {
                  searchText.value = value;
                },
              ),
              Expanded(
                child: Scrollbar(
                  child: ListView.separated(
                    // FABの分大きめにpaddingをとる
                    padding: const EdgeInsets.only(bottom: 180),
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 20),
                    itemCount: mockMemoList.length,
                    itemBuilder:
                        (context, index) =>
                            MemoCard(memoPreview: mockMemoList[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddMemoFab extends HookWidget {
  const _AddMemoFab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isOpen = useState(false);

    const animationDuration = Duration(milliseconds: 300);
    final animationController = useAnimationController(
      duration: animationDuration,
    );
    final slideAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    final editButtonAnimation = Tween<Offset>(
      begin: const Offset(0, 2.9),
      end: Offset.zero,
    ).animate(slideAnimation);
    final micButtonAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(slideAnimation);
    useEffect(() {
      if (isOpen.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [isOpen.value]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SlideTransition(
          position: editButtonAnimation,
          child: FloatingActionButton(
            heroTag: 'add-memo-text-fab',
            mini: true,
            onPressed: () {
              // TODO(Rozelin-dc): メモ追加のダイアログ表示
              debugPrint('メモ追加');
            },
            child: const Icon(Icons.edit),
          ),
        ),
        const SizedBox(height: 10),
        SlideTransition(
          position: micButtonAnimation,
          child: FloatingActionButton(
            heroTag: 'add-memo-voice-fab',
            mini: true,
            onPressed: () async {
              final transcription = await pickTranscribed(context);
              if (transcription == null) return;

              // TODO(Rozelin-dc): メモ追加処理
              debugPrint('音声メモ追加: $transcription');
            },
            child: const Icon(Icons.mic),
          ),
        ),

        const SizedBox(height: 20),

        FloatingActionButton(
          backgroundColor:
              isOpen.value
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.primary,
          foregroundColor:
              isOpen.value
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.onPrimary,
          onPressed: () => isOpen.value = !isOpen.value,
          child: RotationTransition(
            turns: animationController,
            child: Icon(isOpen.value ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }
}

class _TagsHorizontalListView extends StatelessWidget {
  const _TagsHorizontalListView({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = tags[index];
          return _TagChip(tag: tag);
        },
      ),
    );
  }
}

class _TagChip extends HookWidget {
  const _TagChip({required this.tag});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final isSelected = useState(false);

    return FilterChip(
      label: Text(tag.name),
      selected: isSelected.value,
      showCheckmark: false,
      onSelected: (value) {
        // TODO(Rozelin-dc): タグタップによる検索の実装, https://github.com/HACK-U-2025-2/HACKU/issues/75
        isSelected.value = true;
      },
      onDeleted:
          // 選択されていない時に削除ボタンが出ないように
          isSelected.value
              ? () {
                isSelected.value = false;
              }
              : null,
    );
  }
}
