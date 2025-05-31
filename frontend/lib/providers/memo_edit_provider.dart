import 'package:frontend/models/memo.dart';
import 'package:frontend/models/tag.dart';
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

@riverpod
class MemoTagNames extends _$MemoTagNames {
  @override
  List<String> build(MemoId id) {
    return [];
  }

  void setTags(List<Tag> tags) {
    state = tags.map((tag) => tag.name).toList();
  }

  void addTag(String tag) {
    state = [...state, tag];
  }

  void removeTag(String tag) {
    state = state.where((t) => t != tag).toList();
  }
}
