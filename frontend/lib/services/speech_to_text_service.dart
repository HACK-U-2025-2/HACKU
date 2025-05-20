import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:synchronized/synchronized.dart';

abstract class SpeechToTextEvent {}

final class SpeechToTextStartEvent implements SpeechToTextEvent {
  const SpeechToTextStartEvent();
}

final class SpeechToTextStopEvent implements SpeechToTextEvent {
  const SpeechToTextStopEvent();
}

final class SpeechToTextErrorEvent implements SpeechToTextEvent {
  const SpeechToTextErrorEvent(this.message);
  final String message;
}

final class SpeechToTextResultEvent implements SpeechToTextEvent {
  const SpeechToTextResultEvent(this.result);
  final String result;
}

abstract interface class SpeechToTextService {
  Stream<SpeechToTextEvent> get events;
  Future<void> start();
  Future<void> stop();
  void dispose();
}

class SpeechToTextNotAvailableException implements Exception {
  SpeechToTextNotAvailableException();

  @override
  String toString() {
    return 'SpeechToTextNotAvailableException: Speech recognition is not available.';
  }
}

class SimpleSpeechToTextService implements SpeechToTextService {
  SimpleSpeechToTextService();

  final speechToText = SpeechToText();
  final StreamController<SpeechToTextEvent> _controller =
      StreamController<SpeechToTextEvent>.broadcast();

  final _lock = Lock();

  @override
  Stream<SpeechToTextEvent> get events => _controller.stream;

  // startやstopを連続で呼び出せないようにする
  SpeechToTextEvent? _lastEvent;

  @override
  Future<void> start() async {
    if (_lastEvent is SpeechToTextStartEvent) {
      return;
    }

    final isAvailable = await speechToText.initialize(
      onStatus: (status) async {
        debugPrint('Speech recognition status: $status');
        if (status == 'done') {
          // speech_to_text: 7.0.0, iOSにて、doneが即座に2回呼ばれることがある
          // 連続で呼び出すと予期しない動作をすることがあるので、ロックをかける
          await _lock.synchronized(() async {
            await stop();
          });
        }
      },
      onError: (error) {
        debugPrint('Speech recognition error: $error');
        _emit(SpeechToTextErrorEvent(error.errorMsg));
      },
    );

    if (!isAvailable) {
      throw SpeechToTextNotAvailableException();
    }

    await speechToText.listen(
      onResult:
          (result) => _emit(SpeechToTextResultEvent(result.recognizedWords)),
      pauseFor: const Duration(seconds: 3), // 一部Androidでは、より短くなる可能性あり
      localeId: 'ja-JP',
      listenOptions: SpeechListenOptions(listenMode: ListenMode.dictation),
    );
    _emit(const SpeechToTextStartEvent());
  }

  @override
  Future<void> stop() async {
    if (_lastEvent is SpeechToTextStopEvent) {
      return;
    }
    await speechToText.stop();
    _emit(const SpeechToTextStopEvent());
  }

  @override
  void dispose() {
    _controller.close();
  }

  void _emit(SpeechToTextEvent event) {
    _lastEvent = event;
    _controller.add(event);
  }
}
