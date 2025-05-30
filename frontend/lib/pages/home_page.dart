import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/hooks/use_create_memo.dart';
import 'package:frontend/providers/memo_list_provider.dart';
import 'package:frontend/widgets/destination_navigation_drawer.dart';
import 'package:frontend/widgets/memo_card.dart';
import 'package:frontend/widgets/memo_text_field.dart';
import 'package:frontend/widgets/record_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 16;
    final textController = useTextEditingController();
    final focusNode = useFocusNode();

    final submit = useCreateMemo(
      context: context,
      ref: ref,
      afterCreate: textController.clear,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      drawer: const DestinationNavigationDrawer(),
      body: GestureDetector(
        onTap: () {
          // タップ検知可能なWidget以外をタップしたとき、キーボードを閉じる
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              // TODO: 頻出メモを取得するように書き換える
              const _MemoListHeaderLabel(),
              const SizedBox(height: 8),
              const SizedBox(height: 70, child: _MemoHorizontalListView()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MemoTextField(
                    controller: textController,
                    onSubmit: submit,
                    focusNode: focusNode,
                  ),
                ),
              ),
              // 表示スペースの関係上、キーボードが表示されていないときのみRecordButtonを表示
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child:
                    (!isKeyboardVisible)
                        ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: RecordButton(
                            onTranscribed: (transcription) {
                              debugPrint('Transcription: $transcription');
                              if (transcription.isEmpty) return;
                              textController.text += ' $transcription';
                              focusNode.requestFocus();
                            },
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
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
      padding: const EdgeInsets.only(left: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('ランダムMynd', style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

class _MemoHorizontalListView extends ConsumerWidget {
  const _MemoHorizontalListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoPreviews = ref.watch(randomMemoListProvider);

    if (memoPreviews.isLoading && !memoPreviews.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    if (memoPreviews.hasError) {
      return Center(child: Text('エラーが発生しました: ${memoPreviews.error}'));
    }

    final data = memoPreviews.requireValue;

    if (data.isEmpty) {
      return const Center(child: Text('Myndを作成しよう！'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(width: 4),
      itemBuilder: (context, index) {
        final memoPreview = data[index];
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: MemoCard(
            memoPreview: memoPreview,
            showBody: false,
            showFavoriteButton: false,
          ),
        );
      },
    );
  }
}
