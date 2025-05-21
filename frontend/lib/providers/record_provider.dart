import 'package:frontend/services/speech_to_text_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'record_provider.g.dart';

@Riverpod(keepAlive: true)
SpeechToTextService speechToTextService(Ref ref) {
  final impl = SimpleSpeechToTextService();
  ref.onDispose(impl.dispose);
  return impl;
}

@Riverpod(keepAlive: true)
Stream<SpeechToTextEvent> speechToTextEvents(Ref ref) {
  final service = ref.watch(speechToTextServiceProvider);
  return service.events;
}
