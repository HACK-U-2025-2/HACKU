import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/router.gr.dart';
import 'package:frontend/widgets/favorite_icon.dart';

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
      context.router.push(MemoDetailsRoute(memoId: memoPreview.id));
    }

    // TODO(Rozelin-dc): MemoPreviewのフラグを見るようにする
    final isFavorite = useState(false);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showFavoriteButton) ...[
                    Expanded(child: _MemoTitle(title: memoPreview.title)),
                    IconButton(
                      visualDensity: const VisualDensity(
                        vertical: VisualDensity.minimumDensity,
                        horizontal: VisualDensity.minimumDensity,
                      ),
                      icon: FavoriteIcon(isFavorite: isFavorite.value),
                      onPressed: () {
                        isFavorite.value = !isFavorite.value;
                        // TODO(Rozelin-dc): API処理
                      },
                    ),
                  ] else
                    Flexible(child: _MemoTitle(title: memoPreview.title)),
                ],
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
      ),
    );
  }
}

class _MemoTitle extends StatelessWidget {
  const _MemoTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      title,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}
