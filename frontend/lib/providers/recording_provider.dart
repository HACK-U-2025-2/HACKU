import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording_provider.g.dart';

@Riverpod(keepAlive: true)
class IsRecording extends _$IsRecording {
  @override
  bool build() {
    return false;
  }

  void setAsRecording() {
    state = true;
  }

  void setAsNotRecording() {
    state = false;
  }
}
