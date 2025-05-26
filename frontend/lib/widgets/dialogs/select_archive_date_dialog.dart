import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/constant.dart';
import 'package:intl/intl.dart';

class SelectArchiveDateDialog extends HookWidget {
  const SelectArchiveDateDialog({this.initialValue, super.key});

  final DateTime? initialValue;

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final dateFormat = DateFormat(dateTextFormat);
    final textController = useTextEditingController(
      text: initialValue != null ? dateFormat.format(initialValue!) : '',
    );

    final isNotArchive = useState(initialValue == null);
    var tempValue =
        initialValue != null ? dateFormat.format(initialValue!) : '';
    useEffect(() {
      // アーカイブしない設定にしたら、入力欄を空にする。アーカイブする設定にしたら、それまでの入力を復活させる
      if (isNotArchive.value) {
        tempValue = textController.text;
        textController.clear();
      } else {
        textController.text = tempValue;
      }
      return null;
    }, [isNotArchive.value]);

    Future<void> openDatePicker() async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate:
            formKey.currentState?.validate() ?? false
                ? dateFormat.parseStrict(textController.text)
                : null,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        locale: const Locale('ja', 'JP'),
        helpText: 'アーカイブ日を選択',
        cancelText: 'キャンセル',
        confirmText: '選択',
      );
      if (pickedDate != null) {
        textController.text = dateFormat.format(pickedDate);
      }
    }

    return AlertDialog(
      title: const Text('アーカイブ日を変更'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            TextFormField(
              readOnly: isNotArchive.value,
              controller: textController,
              decoration: InputDecoration(
                hintText: isNotArchive.value ? 'アーカイブしません' : dateTextFormat,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: isNotArchive.value ? null : openDatePicker,
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (isNotArchive.value) {
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return 'アーカイブ日を入力してください。';
                }
                try {
                  dateFormat.parseStrict(value);
                } on FormatException catch (_) {
                  return '形式が無効です。';
                }
                return null;
              },
            ),
            CheckboxListTile(
              title: const Text('アーカイブしない'),
              value: isNotArchive.value,
              onChanged: (value) {
                if (value != null) {
                  isNotArchive.value = value;
                }
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
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
              var newDate = '';
              if (!isNotArchive.value) {
                newDate = textController.text;
              }
              Navigator.of(context).pop(newDate);
            }
          },
          child: const Text('変更'),
        ),
      ],
    );
  }
}
