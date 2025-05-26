import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/providers/memo_provider.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/types/extensions/snack_bar.dart';
import 'package:frontend/widgets/dialogs/delete_dialog.dart';
import 'package:frontend/widgets/dialogs/input_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MemoTitleMenu extends ConsumerWidget {
  const MemoTitleMenu({required this.memo, super.key});

  final Memo memo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> updateTitle() async {
      final newTitle = await showDialog<String>(
        context: context,
        builder: (context) => MemoTitleInputDialog(initialValue: memo.title),
      );
      if (newTitle != null && context.mounted) {
        context.loaderOverlay.show();
        try {
          await ref
              .read(memoRepositoryProvider)
              .updateMemoTitle(memo.id, newTitle);
          if (context.mounted) {
            // データを再取得
            ref.invalidate(memoProvider(memo.id));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('タイトルを更新しました')));
          }
        } on Exception catch (e) {
          debugPrint('Error updating memo title: $e');

          if (context.mounted) {
            final message = switch (e) {
              final MemoNotFoundException _ => 'メモが見つかりませんでした。',
              final MemoValidationException _ =>
                '有効なタイトルではありません。メモのタイトルを確認してください。',
              _ => 'タイトルの更新に失敗しました。やり直してください。',
            };
            ScaffoldMessenger.of(context).showErrorSnackBar(message: message);
          }
        } finally {
          if (context.mounted) {
            context.loaderOverlay.hide();
          }
        }
      }
    }

    Future<void> delete() async {
      final isDeletionSelected = await showDialog<bool>(
        context: context,
        builder: (context) => const MemoDeleteDialog(),
      );
      if ((isDeletionSelected ?? false) && context.mounted) {
        context.loaderOverlay.show();
        try {
          await ref.read(memoRepositoryProvider).deleteMemo(memo.id);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('メモを削除しました')));
            Navigator.of(context).pop();
          }
        } on Exception catch (e) {
          debugPrint('Error deleting memo: $e');

          if (context.mounted) {
            final message = switch (e) {
              final MemoNotFoundException _ => 'メモが見つかりませんでした。',
              _ => 'メモの削除に失敗しました。やり直してください。',
            };
            ScaffoldMessenger.of(context).showErrorSnackBar(message: message);
          }
        } finally {
          if (context.mounted) {
            context.loaderOverlay.hide();
          }
        }
      }
    }

    return MenuAnchor(
      style: const MenuStyle(alignment: Alignment.bottomCenter),
      menuChildren: [
        _MenuItemButton(
          icon: Icons.edit,
          label: 'タイトル編集',
          onPressed: updateTitle,
        ),
        _MenuItemButton(icon: Icons.delete, label: '削除', onPressed: delete),
      ],
      builder: (context, controller, child) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.open(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                const SizedBox(width: 16), // バランスを取るためのスペース
                Flexible(child: child!),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      },
      child: Text(
        memo.title,
        style: const TextStyle(overflow: TextOverflow.fade),
      ),
    );
  }
}

class _MenuItemButton extends StatelessWidget {
  const _MenuItemButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: Icon(icon),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
