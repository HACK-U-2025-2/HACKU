import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:manual_speech_to_text/manual_speech_to_text.dart';

class RecordButton extends HookWidget {
  const RecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final recordingState = useState(ManualSttState.stopped);
    final transcribed = useState('');

    final sttController = useMemoized(() {
      final sttController =
          ManualSttController(context)
            ..listen(
              onListeningStateChanged: (state) {
                recordingState.value = state;
              },
              onListeningTextChanged: (recognizedText) {
                debugPrint('Recognized text: $recognizedText');
                transcribed.value = recognizedText;
              },
            )
            ..enableHapticFeedback = true
            ..localId = 'ja';

      debugPrint('STT Controller initialized');
      return sttController;
    });
    useEffect(() => sttController.dispose, [sttController]);

    void start() {
      sttController.startStt();
    }

    void stop() {
      sttController.stopStt();
    }

    final onPressed =
        recordingState.value == ManualSttState.listening ? stop : start;
    final iconData =
        recordingState.value == ManualSttState.listening
            ? Icons.stop
            : Icons.mic;

    return IconButton.filled(
      padding: const EdgeInsets.all(24),
      onPressed: onPressed,
      icon: Icon(iconData, size: 80),
    );
  }
}
