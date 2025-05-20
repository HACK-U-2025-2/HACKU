import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/widgets/dialogs/record_dialog.dart';

typedef OnTranscribed = void Function(String transcription);

class RecordButton extends HookWidget {
  const RecordButton({super.key, this.onTranscribed, this.iconSize = 80});

  final double iconSize;
  final OnTranscribed? onTranscribed;

  @override
  Widget build(BuildContext context) {
    final isRecording = useState(false);

    final iconData = isRecording.value ? Icons.stop : Icons.mic;

    return IconButton.filled(
      padding: const EdgeInsets.all(24),
      onPressed: () async {
        isRecording.value = true;
        final transcription = await pickTranscribed(context);
        isRecording.value = false;

        if (transcription == null) return;

        onTranscribed?.call(transcription);
      },
      icon: Icon(iconData, size: iconSize),
    );
  }
}
