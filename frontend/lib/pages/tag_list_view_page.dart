import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/providers/memo_search_query_provider.dart';
import 'package:frontend/providers/tag_list_provider.dart';
import 'package:frontend/providers/tag_search_query_provider.dart';
import 'package:frontend/router.gr.dart';
import 'package:frontend/widgets/destination_navigation_drawer.dart';
import 'package:frontend/widgets/error_with_refresh.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class TagListViewPage extends HookConsumerWidget {
  const TagListViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagList = ref.watch(tagListProvider);
    final selectedTagNames = useState<Set<String>>({});

    void goToMemoList() {
      ref.read(tagSearchKeywordProvider.notifier).setKeyword('');
      ref
          .read(memoSearchTagNamesProvider.notifier)
          .setTagNames(selectedTagNames.value);
      if (context.mounted) {
        unawaited(context.router.push(const MemoListViewRoute()));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('タグ一覧')),
      drawer: const DestinationNavigationDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 16,
            children: [
              const _SearchBar(),
              Expanded(
                child:
                    tagList.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : tagList.hasError
                        ? ErrorWithRefresh(
                          errorMessage: 'タグの取得に失敗しました。やり直してください',
                          onRefresh: () => ref.invalidate(tagListProvider),
                        )
                        : Scrollbar(
                          child: ListView(
                            children:
                                tagList.requireValue
                                    .map(
                                      (tag) => CheckboxListTile(
                                        title: Text(tag.name),
                                        // TODO(Rozelin-dc): メモ数の表示
                                        value: selectedTagNames.value.contains(
                                          tag.name,
                                        ),
                                        onChanged: (value) {
                                          if (value == null) {
                                            return;
                                          }
                                          if (value) {
                                            selectedTagNames.value = {
                                              ...selectedTagNames.value,
                                              tag.name,
                                            };
                                          } else {
                                            selectedTagNames.value = {
                                              ...selectedTagNames.value,
                                            }..remove(tag.name);
                                          }
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed:
                          selectedTagNames.value.isEmpty
                              ? null
                              : () {
                                selectedTagNames.value = {};
                              },
                      icon: const Icon(Icons.close),
                      label: const Text('選択解除'),
                    ),
                  ),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed:
                          selectedTagNames.value.isEmpty ? null : goToMemoList,
                      icon: const Icon(Icons.search),
                      label: const Text('検索'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends HookConsumerWidget {
  const _SearchBar();

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
            .read(tagSearchKeywordProvider.notifier)
            .setKeyword(debouncedSearchText ?? '');
      });
      return null;
    }, [debouncedSearchText]);

    // 表示と内部処理の不整合を防ぐため、dispose時に検索クエリをクリア
    useEffect(
      () => () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(tagSearchKeywordProvider.notifier).setKeyword('');
        });
      },
      [],
    );

    return SearchBar(
      leading: const Icon(Icons.search),
      hintText: '検索キーワードを入力',
      onChanged: (value) {
        searchText.value = value;
      },
    );
  }
}
