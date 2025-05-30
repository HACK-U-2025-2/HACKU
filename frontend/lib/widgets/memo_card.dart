import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/router.gr.dart';
import 'package:frontend/widgets/favorite_button.dart';

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

    // 一覧系の画面ではお気に入り状態の変更だけで再度APIを叩きたくないので、表示用にstateを用意する
    final isFavorite = useState(memoPreview.isFavorite);

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
                FavoriteButton(
                  memoId: memoPreview.id,
                  isFavorite: isFavorite.value,
                  afterToggle: () {
                    isFavorite.value = !isFavorite.value;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
