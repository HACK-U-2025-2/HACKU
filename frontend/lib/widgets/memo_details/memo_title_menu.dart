import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/widgets/dialogs/delete_dialog.dart';
import 'package:frontend/widgets/dialogs/input_dialog.dart';

class MemoTitleMenu extends StatelessWidget {
  const MemoTitleMenu({required this.memo, super.key});

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    Future<void> updateTitle() async {
      final newTitle = await showDialog<String>(
        context: context,
        builder: (context) => MemoTitleInputDialog(initialValue: memo.title),
      );
      if (newTitle != null) {
        // TODO(tyPhoon-collab): メモタイトル更新の処理を実装する
      }
    }

    Future<void> delete() async {
      final isDeletionSelected = await showDialog<bool>(
        context: context,
        builder: (context) => const MemoDeleteDialog(),
      );
      if (isDeletionSelected ?? false) {
        // TODO(tyPhoon-collab): メモ削除の処理を実装する
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
