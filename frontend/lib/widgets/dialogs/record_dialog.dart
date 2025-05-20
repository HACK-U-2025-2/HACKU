import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/providers/recording_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';

Future<String?> pickTranscribed(BuildContext context, WidgetRef ref) async {
  final result = await showDialog<String?>(
    context: context,
    builder: (context) => const RecordDialog(),
  );

  if (result == null) {
    return null;
  }

  return result;
}

class RecordDialog extends HookConsumerWidget {
  const RecordDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transcribed = useState('');

    final sttController = useMemoized(() {
      final sttController =
          ManualSttController(context)
            ..listen(
              onListeningStateChanged: (state) {
                if (state == ManualSttState.listening) {
                  ref.read(isRecordingProvider.notifier).setAsRecording();
                } else {
                  ref.read(isRecordingProvider.notifier).setAsNotRecording();
                }
              },
              onListeningTextChanged: (recognizedText) {
                debugPrint('Recognized text: $recognizedText');
                transcribed.value = recognizedText;
              },
            )
            ..enableHapticFeedback = true;

      debugPrint('STT Controller initialized');
      return sttController;
    });

    void start() {
      sttController.startStt();
    }

    void stop() {
      sttController.stopStt();
    }

    useEffect(() {
      start();
      return sttController.dispose;
    }, [sttController]);

    return AlertDialog(
      title: const Text('音声入力中'),
      content: Text(
        transcribed.value.isEmpty ? 'メモの内容を話してください' : transcribed.value,
      ),
      actions: [
        TextButton(
          onPressed: () {
            stop();
            Navigator.of(context).pop();
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            stop();
            Navigator.of(context).pop(transcribed.value);
          },
          child: const Text('完了'),
        ),
      ],
    );
  }
}
