import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/providers/recording_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';

/// 音声入力を行うダイアログを表示し、文字起こしされたテキストを返す
Future<String?> pickTranscribed(BuildContext context, WidgetRef ref) async {
  final result = await showDialog<String?>(
    context: context,
    barrierDismissible: false, // 処理をシンプルにするために、画面外をタップしても閉じないようにする
    builder: (context) => const _RecordDialog(),
  );

  if (result == null) {
    return null;
  }

  return result;
}

class _RecordDialog extends HookConsumerWidget {
  const _RecordDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transcribed = useState('');

    // 今回使用しているSTTライブラリの録音の停止が非同期かつ、awaitできないため
    // 録音の停止の管理をonListeningStateChangedで管理する
    // そのとき、文字起こしを返すかどうかをフラグで管理する
    final shouldPop = useState(false);
    final shouldReturnTranscription = useState(false);

    final sttController = useMemoized(() {
      final sttController =
          ManualSttController(context)
            ..listen(
              onListeningStateChanged: (state) {
                if (state == ManualSttState.listening) {
                  ref.read(isRecordingProvider.notifier).setAsRecording();
                } else {
                  ref.read(isRecordingProvider.notifier).setAsNotRecording();
                  if (shouldPop.value) {
                    Navigator.of(context).pop(
                      shouldReturnTranscription.value
                          ? transcribed.value
                          : null,
                    );
                  }
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
      icon: const Icon(Icons.mic),
      title: const Text('音声入力中'),
      content: Text(
        transcribed.value.isEmpty ? 'メモの内容を話してください' : transcribed.value,
      ),
      actions: [
        TextButton(
          onPressed: () {
            stop();
            shouldPop.value = true;
            shouldReturnTranscription.value = false;
          },
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            stop();
            shouldPop.value = true;
            shouldReturnTranscription.value = true;
          },
          child: const Text('完了'),
        ),
      ],
    );
  }
}
