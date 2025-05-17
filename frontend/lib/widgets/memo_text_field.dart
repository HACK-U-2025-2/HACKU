import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MemoTextField extends HookWidget {
  const MemoTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final textController = useTextEditingController();

    void submit() {
      if (formKey.currentState?.validate() ?? false) {
        // TODO: サーバに送信
        final text = textController.text.trim();
        textController.clear();
        debugPrint('Memo submitted: $text');
      }
    }

    return Form(
      key: formKey,
      child: TextFormField(
        controller: textController,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        minLines: 1,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '空のメモは作成できません';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'メモを入力してください',
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
