import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

extension type const TagId(int value) {}

@freezed
sealed class Tag with _$Tag {
  const factory Tag({
    @TagIdJsonConverter() required TagId id,
    required String name,
    @Default(0) int usedNum,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

final class TagIdJsonConverter implements JsonConverter<TagId, int> {
  const TagIdJsonConverter();

  @override
  TagId fromJson(int json) => TagId(json);

  @override
  int toJson(TagId object) => object.value;
}
