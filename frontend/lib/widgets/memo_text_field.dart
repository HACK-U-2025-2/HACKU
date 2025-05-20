import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnSubmit = void Function(String raw);

class MemoTextField extends HookWidget {
  const MemoTextField({
    required this.controller,
    required this.onSubmit,
    this.focusNode,
    super.key,
  });

  final OnSubmit? onSubmit;
  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(GlobalKey<FormState>.new);

    void submit() {
      if (formKey.currentState?.validate() ?? false) {
        final text = controller.text.trim();
        onSubmit?.call(text);
      }
    }

    return Form(
      key: formKey,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        expands: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '空のメモは作成できません';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'メモを入力してください',
          alignLabelWithHint: true,
          filled: true,
          fillColor: colorScheme.secondaryContainer,
          contentPadding: const EdgeInsets.all(16),
          suffix: IconButton.filled(
            icon: Icon(Icons.arrow_forward, color: colorScheme.onPrimary),
            onPressed: submit,
          ),
        ),
      ),
    );
  }
}
