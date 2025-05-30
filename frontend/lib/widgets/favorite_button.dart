import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:frontend/types/extensions/snack_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    required this.memoId,
    required this.isFavorite,
    this.afterToggle,
    super.key,
  });

  final MemoId memoId;
  final bool isFavorite;
  final VoidCallback? afterToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(isFavorite ? Icons.lock : Icons.lock_open),
      onPressed: () async {
        try {
          await ref
              .read(memoRepositoryProvider)
              .updateMemoFavorite(memoId, isFavorite: !isFavorite);
          afterToggle?.call();
        } on Exception catch (e) {
          debugPrint('Error update memo.isFavorite: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showErrorSnackBar(message: 'Myndのロック設定更新に失敗しました。やり直してください');
          }
        }
      },
    );
  }
}
