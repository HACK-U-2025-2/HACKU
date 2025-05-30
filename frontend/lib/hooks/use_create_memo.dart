import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/memo_list_provider.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:frontend/router.gr.dart';
import 'package:frontend/types/extensions/snack_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

Future<void> Function(String) useCreateMemo({
  required BuildContext context,
  required WidgetRef ref,
  void Function()? afterCreate,
}) {
  return (String raw) async {
    context.loaderOverlay.show();
    try {
      final memo = await ref.read(memoRepositoryProvider).addMemo(raw);
      if (afterCreate != null) {
        afterCreate();
      }
      if (context.mounted) {
        ref.invalidate(randomMemoListProvider);
        unawaited(context.router.push(MemoDetailsRoute(memoId: memo.id)));
      }
    } on Exception catch (e) {
      debugPrint('Error adding memo: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showErrorSnackBar(message: 'Myndの追加に失敗しました。やり直してください');
      }
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    }
  };
}
