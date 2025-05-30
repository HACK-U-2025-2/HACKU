import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/router.dart';

/// ドロワーが表示される画面まで一気に戻るボタン
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        context.router.popUntil((route) => route.data?.toDestination() != null);
      },
    );
  }
}
