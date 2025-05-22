import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_edit_provider.g.dart';

@riverpod
class IsEditingMode extends _$IsEditingMode {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}
