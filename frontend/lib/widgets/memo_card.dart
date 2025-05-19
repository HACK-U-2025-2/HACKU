import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/pages/memo_details_page.dart';

class MemoCard extends HookWidget {
  const MemoCard({required this.memoPreview, super.key, this.showBody = true});

  final MemoPreview memoPreview;
  final bool showBody;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void onTap() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          // TODO(anyone): memoPreview.idを渡す, https://github.com/HACK-U-2025-2/HACKU/issues/22
          builder: (context) => const MemoDetailsPage(),
        ),
      );
    }

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
      ),
    );
  }
}
