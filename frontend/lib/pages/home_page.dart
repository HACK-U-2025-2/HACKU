import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:frontend/router.gr.dart';
import 'package:frontend/widgets/destination_navigation_drawer.dart';
import 'package:frontend/widgets/memo_text_field.dart';
import 'package:frontend/widgets/record_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 16;
    final textController = useTextEditingController();
    final focusNode = useFocusNode();

    Future<void> submit(String raw) async {
      textController.clear();
      context.loaderOverlay.show();
      final memo = await ref.read(memoRepositoryProvider).addMemo(raw);
      if (context.mounted) {
        context.loaderOverlay.hide();
        unawaited(context.router.push(MemoDetailsRoute(memoId: memo.id)));
      }
    }

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
              const _MemoListHeaderLabel(),
              const SizedBox(height: 8),
              const SizedBox(height: 60, child: _MemoHorizontalListView()),
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
        // TODO(tyPhoon-collab): MemoCardに統合する
        // 仮置きのWidgetを採用中
        return const _MiniMemoCard();
      },
    );
  }
}

class _MiniMemoCard extends StatelessWidget {
  const _MiniMemoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'メモタイトル',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
