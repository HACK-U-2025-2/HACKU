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
        context.router.popUntil((route) {
          final destination = route.data?.toDestination();
          // 思考空間はドロワー内に存在するが、思考空間ページにドロワーが表示されない
          return destination != null && destination != Destination.sphere;
        });
      },
    );
  }
}
