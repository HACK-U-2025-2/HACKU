import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/widgets/dialogs/delete_dialog.dart';
import 'package:frontend/widgets/dialogs/input_dialog.dart';
import 'package:frontend/widgets/dialogs/select_archive_date_dialog.dart';

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

    Future<void> updateArchiveDate() async {
      final newDate = await showDialog<String?>(
        context: context,
        builder: (context) {
          return SelectArchiveDateDialog(
            // TODO(Rozelin-dc): memoを参照して初期値を設定
            initialValue: DateTime.now(),
          );
        },
      );
      if (newDate != null) {
        // TODO(Rozelin-dc): API処理。空文字ならアーカイブしない
        debugPrint('新しいアーカイブ日: $newDate');
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
        _MenuItemButton(
          icon: Icons.archive_outlined,
          // TODO(Rozelin-dc): アーカイブ日を表示する
          label: 'アーカイブ予定なし',
          // TODO(Rozelin-dc): お気に入りされていたらアーカイブ不可なので、ダイアログが開かないようにする
          onPressed: updateArchiveDate,
        ),
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
