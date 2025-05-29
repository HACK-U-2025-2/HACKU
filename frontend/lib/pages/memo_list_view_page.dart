import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/hooks/use_create_memo.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/memo_list_provider.dart';
import 'package:frontend/providers/memo_search_query_provider.dart';
import 'package:frontend/providers/tag_list_provider.dart';
import 'package:frontend/widgets/destination_navigation_drawer.dart';
import 'package:frontend/widgets/dialogs/input_dialog.dart';
import 'package:frontend/widgets/dialogs/record_dialog.dart';
import 'package:frontend/widgets/dialogs/sort_dialog.dart';
import 'package:frontend/widgets/error_with_refresh.dart';
import 'package:frontend/widgets/memo_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MemoListViewPage extends StatefulHookConsumerWidget {
  const MemoListViewPage({super.key});

  @override
  ConsumerState<MemoListViewPage> createState() => _MemoListViewPageState();
}

class _MemoListViewPageState extends ConsumerState<MemoListViewPage>
    with AutoRouteAwareStateMixin {
  @override
  void didPopNext() {
    super.didPopNext();
    // ページに戻ってきたときにメモとタグの一覧を再取得
    ref
      ..invalidate(memoListProvider)
      ..invalidate(tagListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final memoList = ref.watch(memoListProvider);

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
              const _TagsHorizontalListView(),
              _SearchBar(),
              Expanded(
                child:
                    memoList.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : memoList.hasError
                        ? Center(
                          child: ErrorWithRefresh(
                            errorMessage: 'メモの取得に失敗しました。やり直してください',
                            onRefresh: () {
                              ref.invalidate(memoListProvider);
                            },
                          ),
                        )
                        : memoList.requireValue.isEmpty
                        ? const Center(child: Text('メモがまだありません'))
                        : Scrollbar(
                          child: ListView.separated(
                            // FABの分大きめにpaddingをとる
                            padding: const EdgeInsets.only(bottom: 180),
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 20),
                            itemCount: memoList.requireValue.length,
                            itemBuilder:
                                (context, index) => MemoCard(
                                  memoPreview: memoList.requireValue[index],
                                ),
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

class _AddMemoFab extends HookConsumerWidget {
  const _AddMemoFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final isOpen = useState(false);

    const animationDuration = Duration(milliseconds: 300);
    const animationCurve = Curves.easeOut;

    final submitNewMemo = useCreateMemo(
      context: context,
      ref: ref,
      afterCreate: () => isOpen.value = false,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSlide(
          offset: isOpen.value ? Offset.zero : const Offset(0, 2.9),
          duration: animationDuration,
          curve: animationCurve,
          child: FloatingActionButton.small(
            heroTag: null,
            onPressed: () async {
              final rawMemo = await showDialog<String>(
                context: context,
                builder: (context) => const AddMemoFromTextDialog(),
              );
              if (rawMemo != null) {
                await submitNewMemo(rawMemo);
              }
            },
            child: const Icon(Icons.edit),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSlide(
          offset: isOpen.value ? Offset.zero : const Offset(0, 1.6),
          duration: animationDuration,
          curve: animationCurve,
          child: FloatingActionButton.small(
            heroTag: null,
            onPressed: () async {
              final transcription = await pickTranscribed(context);
              if (transcription != null) {
                await submitNewMemo(transcription);
              }
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
          child: AnimatedRotation(
            turns: isOpen.value ? 0.5 : 0,
            duration: animationDuration,
            curve: animationCurve,
            child: Icon(isOpen.value ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }
}

class _TagsHorizontalListView extends HookConsumerWidget {
  const _TagsHorizontalListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(sprint2): タグを全て取得するのではなく、数を絞りたい
    final tags = ref.watch(tagListProvider);

    final selectedTagNames = useState<Set<String>>({});
    final debouncedSelectedTagNames = useDebounced(
      selectedTagNames.value,
      const Duration(milliseconds: searchRequestDurationMilliseconds),
    );
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (debouncedSelectedTagNames != null) {
          ref
              .read(memoSearchTagNamesProvider.notifier)
              .setTagNames(debouncedSelectedTagNames.toList());
        }
      });
      return null;
    }, [debouncedSelectedTagNames]);

    return SizedBox(
      height: 50,
      child:
          tags.isLoading
              ? const Center(child: CircularProgressIndicator())
              : tags.hasError
              ? ErrorWithRefresh(
                errorMessage: 'タグの取得に失敗しました',
                onRefresh: () {
                  ref.invalidate(tagListProvider);
                },
                isRow: true,
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: tags.requireValue.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tag = tags.requireValue[index];
                  return _TagChip(
                    tag: tag,
                    isSelected: selectedTagNames.value.contains(tag.name),
                    onSelected: () {
                      selectedTagNames.value = {
                        ...selectedTagNames.value,
                        tag.name,
                      };
                    },
                    onUnselected: () {
                      selectedTagNames.value = {...selectedTagNames.value}
                        ..remove(tag.name);
                    },
                  );
                },
              ),
    );
  }
}

class _TagChip extends HookConsumerWidget {
  const _TagChip({
    required this.tag,
    required this.isSelected,
    required this.onSelected,
    required this.onUnselected,
  });

  final Tag tag;
  final bool isSelected;
  final VoidCallback onSelected;
  final VoidCallback onUnselected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilterChip(
      label: Text(tag.name),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (value) => onSelected(),
      onDeleted:
          // 選択されていない時に削除ボタンが出ないように
          isSelected ? onUnselected : null,
    );
  }
}

class _SearchBar extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = useState('');
    final debouncedSearchText = useDebounced(
      searchText.value,
      const Duration(milliseconds: searchRequestDurationMilliseconds),
    );
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(memoSearchKeywordProvider.notifier)
            .setKeyword(debouncedSearchText ?? '');
      });
      return null;
    }, [debouncedSearchText]);

    final sortOption = ref.watch(memoSearchSortOptionProvider);

    return SearchBar(
      leading: const Icon(Icons.search),
      trailing: [
        IconButton(
          icon: const Icon(Icons.swap_vert),
          onPressed: () async {
            final newSortOption = await showDialog<MemoSortOption?>(
              context: context,
              builder:
                  (context) => MemoSortDialog(initialSortOption: sortOption),
            );
            if (newSortOption != null) {
              ref
                  .read(memoSearchSortOptionProvider.notifier)
                  .setSortOption(newSortOption);
            }
          },
        ),
      ],
      hintText: '検索キーワードを入力',
      onChanged: (value) {
        searchText.value = value;
      },
    );
  }
}
