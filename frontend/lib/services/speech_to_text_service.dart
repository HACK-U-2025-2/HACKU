import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:frontend/constant.dart';
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

  // speech_to_text: 7.0.0, iOSにて、doneが即座に2回呼ばれることがある
  // eventが2回発火するのを防ぐためのフラグ
  bool _hasEmittedDoneEvent = false;

  @override
  Stream<SpeechToTextEvent> get events => _controller.stream;

  @override
  Future<void> start() {
    return _lock.synchronized(_start);
  }

  @override
  Future<void> stop() {
    return _lock.synchronized(_stop);
  }

  Future<void> _start() async {
    if (speechToText.isListening) {
      debugPrint('Already started');
      return;
    }

    _hasEmittedDoneEvent = false;

    final isAvailable = await speechToText.initialize(
      onStatus: (status) async {
        debugPrint('Speech recognition status: $status');
        if (status == 'done') {
          if (!_hasEmittedDoneEvent) {
            _emitStop();
            _hasEmittedDoneEvent = true;
          } else {
            debugPrint('Duplicate done event, ignoring');
          }
        }
      },
      onError: (error) {
        debugPrint('Speech recognition error: $error');
        _emitError(error.errorMsg);
      },
    );

    if (!isAvailable) {
      throw SpeechToTextNotAvailableException();
    }

    await speechToText.listen(
      onResult: (result) => _emitResult(result.recognizedWords),
      pauseFor: const Duration(
        seconds: speechToTextAutoPauseSeconds,
      ), // 一部Androidでは、より短くなる可能性あり
      localeId: 'ja-JP',
      listenOptions: SpeechListenOptions(listenMode: ListenMode.dictation),
    );
    _emitStart();
  }

  Future<void> _stop() async {
    if (speechToText.isNotListening) {
      debugPrint('Already stopped');
      return;
    }
    await speechToText.stop();
  }

  @override
  void dispose() {
    _controller.close();
  }

  void _emit(SpeechToTextEvent event) {
    _controller.add(event);
    // debugPrint('Emit event: $event');
  }

  void _emitStart() => _emit(const SpeechToTextStartEvent());

  void _emitStop() => _emit(const SpeechToTextStopEvent());

  void _emitError(String message) => _emit(SpeechToTextErrorEvent(message));

  void _emitResult(String result) => _emit(SpeechToTextResultEvent(result));
}
