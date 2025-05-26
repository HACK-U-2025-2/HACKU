import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/providers/memo_edit_provider.dart';
import 'package:frontend/widgets/memo_card.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoBodyView extends HookConsumerWidget {
  const MemoBodyView({required this.memo, super.key});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditingMode = ref.watch(isEditingModeProvider);

    // TODO(Rozelin-dc): memoを参照する
    final relatedMemos = List.generate(
      3,
      (index) => MemoPreview(
        id: MemoId(index),
        title: 'メモタイトル$index',
        body: 'メモ$indexの要約',
        createdAt: DateTime.now(),
      ),
    );

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
            '関連メモ',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: relatedMemos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final relatedMemo = relatedMemos[index];
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
            child: _EditToolBar(controller: controller),
          ),
        ],
      ),
    );
  }
}

class _EditToolBar extends ConsumerWidget {
  const _EditToolBar({required this.controller});

  final QuillController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  ref.read(isEditingModeProvider.notifier).toggle();
                },
              ),
              IconButton.filled(
                icon: const Icon(Icons.check),
                onPressed: () {
                  ref.read(isEditingModeProvider.notifier).toggle();
                  // TODO(tyPhoon-collab): 保存処理を実装する
                  final newBody = controller.document.toPlainText();
                  debugPrint('New Body: $newBody');
                },
              ),
            ],
          ),
    );
  }
}
