import 'package:flutter/material.dart';

class MemoTextField extends StatelessWidget {
  const MemoTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      maxLines: null,
      minLines: 1,
      decoration: InputDecoration(
        labelText: 'メモを入力してください',
        filled: true,
        fillColor: colorScheme.secondaryContainer,
        contentPadding: const EdgeInsets.all(16),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: IconButton.filled(
            icon: Icon(Icons.arrow_forward, color: colorScheme.onPrimary),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
