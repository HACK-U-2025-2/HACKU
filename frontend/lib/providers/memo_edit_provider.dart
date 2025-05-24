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
  List<String> build() {
    return [];
  }

  void setTags(List<Tag> tags) {
    state = tags.map((tag) => tag.name).toList();
  }

  void addTag(String tag) {
    state = [...state, tag];
    _update();
  }

  void removeTag(String tag) {
    state = state.where((t) => t != tag).toList();
    _update();
  }

  void _update() {
    // TODO(tyPhoon-collab): タグを削除する処理を実装する
  }
}
