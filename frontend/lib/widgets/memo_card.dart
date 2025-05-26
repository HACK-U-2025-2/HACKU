import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/router.gr.dart';

class MemoCard extends HookWidget {
  const MemoCard({
    required this.memoPreview,
    super.key,
    this.showBody = true,
    this.showFavoriteButton = true,
  });

  final MemoPreview memoPreview;
  final bool showBody;
  final bool showFavoriteButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void onTap() {
      // TODO(anyone): memoPreview.idを渡す, https://github.com/HACK-U-2025-2/HACKU/issues/22
      context.router.push(const MemoDetailsRoute());
    }

    // TODO(Rozelin-dc): MemoPreviewのフラグを見るようにする
    final isFavorite = useState(false);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      memoPreview.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (showBody)
                      Text(
                        memoPreview.body,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                  ],
                ),
              ),
              if (showFavoriteButton)
                IconButton(
                  icon: Icon(
                    isFavorite.value
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                  ),
                  onPressed: () {
                    isFavorite.value = !isFavorite.value;
                    // TODO(Rozelin-dc): API処理
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
