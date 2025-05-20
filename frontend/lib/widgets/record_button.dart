import 'package:flutter/material.dart';
import 'package:frontend/providers/recording_provider.dart';
import 'package:frontend/widgets/dialogs/record_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordButton extends HookConsumerWidget {
  const RecordButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingProvider);

    final iconData = isRecording ? Icons.stop : Icons.mic;

    return IconButton.filled(
      padding: const EdgeInsets.all(24),
      onPressed: () {
        final transcription = pickTranscribed(context, ref);
        debugPrint('Transcription: $transcription');
      },
      icon: Icon(iconData, size: 80),
    );
  }
}
