import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/widgets/dialogs/delete_dialog.dart';
import 'package:frontend/widgets/dialogs/input_dialog.dart';

class MemoTitleMenu extends StatelessWidget {
  const MemoTitleMenu({required this.memo, super.key});

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: const MenuStyle(alignment: Alignment.bottomCenter),
      menuChildren: [
        MenuItemButton(
          child: const _MenuActionItem(icon: Icons.edit, label: 'タイトル編集'),
          onPressed: () async {
            final newTitle = await showDialog<String>(
              context: context,
              builder:
                  (context) => MemoTitleUpdateDialog(initialValue: memo.title),
            );
            if (newTitle != null) {
              // TODO(tyPhoon-collab): メモタイトル更新の処理を実装する
            }
          },
        ),
        MenuItemButton(
          child: const _MenuActionItem(icon: Icons.delete, label: '削除'),
          onPressed: () async {
            final isDeletionSelected = await showDialog<bool>(
              context: context,
              builder: (context) => const MemoDeleteDialog(),
            );
            if (isDeletionSelected ?? false) {
              // TODO(tyPhoon-collab): メモ削除の処理を実装する
            }
          },
        ),
      ],
      builder: (context, controller, child) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.open(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                const SizedBox(width: 16),
                child!,
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

class _MenuActionItem extends StatelessWidget {
  const _MenuActionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon), Text(label)],
    );
  }
}
