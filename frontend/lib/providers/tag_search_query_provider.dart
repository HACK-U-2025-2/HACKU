import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tag_search_query_provider.g.dart';

@riverpod
class TagSearchKeyword extends _$TagSearchKeyword {
  @override
  String build() {
    return '';
  }

  void setKeyword(String keyword) {
    state = keyword;
  }
}
