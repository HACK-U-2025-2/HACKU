import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/providers/record_provider.dart';
import 'package:frontend/services/speech_to_text_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final speech = ref.watch(speechToTextServiceProvider);
    final errorMessage = useState<String?>(null);
    final shouldReturnValue = useState<bool>(true);
    final isRecording = useState<bool>(false);

    ref.listen(speechToTextEventsProvider, (prev, next) {
      if (next.value == null) return;
      switch (next.requireValue) {
        case final SpeechToTextResultEvent result:
          debugPrint('SpeechToTextResultEvent: ${result.result}');
          transcribed.value = result.result;
        case final SpeechToTextStartEvent _:
          isRecording.value = true;
        case final SpeechToTextStopEvent _:
          Navigator.of(
            context,
          ).pop(shouldReturnValue.value ? transcribed.value : null);
        case final SpeechToTextErrorEvent error:
          errorMessage.value = error.message;
      }
    });

    useEffect(() {
      Future<void> initSpeech() async {
        try {
          await speech.start();
        } on SpeechToTextNotAvailableException catch (e) {
          errorMessage.value = e.toString();
          debugPrint('Speech recognition is not available: $e');
        } on Exception catch (e) {
          errorMessage.value = e.toString();
          debugPrint('Error initializing speech recognition: $e');
        }
      }

      initSpeech();
      return null;
    }, [speech]); // 依存関係にspeechToTextとrefを含める

    return AlertDialog(
      icon: const Icon(Icons.mic),
      title: const Text('音声入力中'),
      content:
          errorMessage.value != null
              ? Text(errorMessage.value!)
              : isRecording.value
              ? Text(
                transcribed.value.isEmpty ? 'メモの内容を話してください' : transcribed.value,
              )
              : const Text('音声入力準備中...'),
      actions: [
        TextButton(
          onPressed: () {
            shouldReturnValue.value = false;
            speech.stop();
          },
          child: const Text('キャンセル'),
        ),
        if (isRecording.value && errorMessage.value == null)
          TextButton(
            onPressed: () {
              shouldReturnValue.value = true;
              speech.stop();
            },
            child: const Text('完了'),
          ),
      ],
    );
  }
}
