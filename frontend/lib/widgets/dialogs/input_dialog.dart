import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/constant.dart';

class InputDialog extends HookWidget {
  const InputDialog({
    required this.title,
    required this.actionLabel,
    this.hintText,
    this.initialValue,
    this.validator,
    this.maxLength,
    super.key,
  });

  final String title;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final String actionLabel;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final textController = useTextEditingController(text: initialValue);

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: TextFormField(
          maxLength: maxLength,
          validator: validator,
          autofocus: true,
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(textController.text);
            }
          },
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class MemoTitleUpdateDialog extends StatelessWidget {
  const MemoTitleUpdateDialog({required this.initialValue, super.key});

  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return InputDialog(
      title: 'タイトルを編集',
      actionLabel: '変更',
      hintText: 'メモのタイトル',
      initialValue: initialValue,
      maxLength: memoTitleMaxLength,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'タイトルを入力してください';
        }
        return null;
      },
    );
  }
}
