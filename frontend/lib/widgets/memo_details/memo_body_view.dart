import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/providers/memo_edit_provider.dart';
import 'package:frontend/providers/memo_provider.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/types/extensions/snack_bar.dart';
import 'package:frontend/widgets/error_with_refresh.dart';
import 'package:frontend/widgets/memo_card.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MemoBodyView extends HookConsumerWidget {
  const MemoBodyView({required this.memo, super.key});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditingMode = ref.watch(isEditingModeProvider);

    final relatedMemos = ref.watch(relatedMemosProvider(memo.id));

    if (isEditingMode) {
      return _EditView(memo);
    }

    return SingleChildScrollView(
      // FABとの重なりを避けるために、下部に余白を追加
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GptMarkdown(memo.body),
          const SizedBox(height: 30),
          const Divider(),
          Text(
            '関連Mynd',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (relatedMemos.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (relatedMemos.hasError)
            Center(
              child: ErrorWithRefresh(
                errorMessage: '関連Myndの取得に失敗しました。やり直してください。',
                onRefresh: () {
                  ref.invalidate(relatedMemosProvider(memo.id));
                },
              ),
            )
          else if (relatedMemos.requireValue.isEmpty)
            const Text('関連Myndはありません。')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: relatedMemos.requireValue.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final relatedMemo = relatedMemos.requireValue[index];
                return MemoCard(memoPreview: relatedMemo, showBody: false);
              },
            ),
        ],
      ),
    );
  }
}

// TODO(tyPhoon-collab): MemoRawViewと共通化
class _EditView extends HookWidget {
  const _EditView(this.memo);

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(QuillController.basic);

    useEffect(() {
      controller.document.insert(0, memo.body);
      controller.document.history.clear();
      return controller.dispose;
    }, [controller]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: QuillEditor.basic(controller: controller)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _EditToolBar(memo: memo, controller: controller),
          ),
        ],
      ),
    );
  }
}

class _EditToolBar extends ConsumerWidget {
  const _EditToolBar({required this.memo, required this.controller});

  final Memo memo;
  final QuillController controller;

  MemoId get id => memo.id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// BodyとTagsを更新する
    Future<void> update() async {
      final repo = ref.read(memoRepositoryProvider);
      final newBody = controller.document.toPlainText();
      final newTags = ref.read(memoTagNamesProvider(id));

      final wasBodyChanged = newBody.trim() != memo.body.trim();
      final wasTagsChanged = !listEquals(newTags, memo.tagNames);
      final wasChanged = wasBodyChanged || wasTagsChanged;

      if (!wasChanged) return;

      context.loaderOverlay.show();
      try {
        // 本文が変更されている場合のみ更新
        if (wasBodyChanged) {
          await repo.updateMemoBody(id, newBody);
        }
        // タグが変更されている場合のみ更新
        if (wasTagsChanged) {
          await repo.updateMemoTags(id, newTags);
        }

        if (context.mounted) {
          // データを再取得
          ref.invalidate(memoProvider(id));

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Myndを更新しました。')));
        }
      } on Exception catch (e) {
        debugPrint('Error updating memo body: $e');

        if (context.mounted) {
          final message = switch (e) {
            final MemoNotFoundException _ => 'Myndが見つかりません。',
            final MemoValidationException _ => '有効な内容ではありません。Myndの内容を確認してください。',
            _ => 'Myndの更新に失敗しました。やり直してください。',
          };
          ScaffoldMessenger.of(context).showErrorSnackBar(message: message);
        }
      } finally {
        if (context.mounted) {
          context.loaderOverlay.hide();
        }
      }
    }

    return ListenableBuilder(
      listenable: controller,
      builder:
          (context, _) => Row(
            spacing: 16,
            children: [
              IconButton.filledTonal(
                icon: const Icon(Icons.undo),
                onPressed: controller.hasUndo ? controller.undo : null,
                tooltip: 'Undo',
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.redo),
                onPressed: controller.hasRedo ? controller.redo : null,
                tooltip: 'Redo',
              ),
              const Spacer(),
              IconButton.outlined(
                icon: const Icon(Icons.close),
                onPressed: () {
                  // もともとのメモのタグの内容にリセット
                  ref
                      .read(memoTagNamesProvider(id).notifier)
                      .setTags(memo.tags);
                  ref.read(isEditingModeProvider.notifier).toggle();
                },
              ),
              IconButton.filled(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  await update();
                  ref.read(isEditingModeProvider.notifier).toggle();
                },
              ),
            ],
          ),
    );
  }
}
