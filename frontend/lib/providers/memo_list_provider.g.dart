// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memoListHash() => r'7266ccf85d0f78b961824e101f6ed8bea7e6f56c';

/// See also [memoList].
@ProviderFor(memoList)
final memoListProvider = AutoDisposeFutureProvider<List<MemoPreview>>.internal(
  memoList,
  name: r'memoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$memoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MemoListRef = AutoDisposeFutureProviderRef<List<MemoPreview>>;
String _$memoEmbeddingsHash() => r'9dac5e5c74c0ffe866b0feaa9b50fcd611576887';

/// See also [memoEmbeddings].
@ProviderFor(memoEmbeddings)
final memoEmbeddingsProvider =
    AutoDisposeFutureProvider<List<MemoEmbedding>>.internal(
      memoEmbeddings,
      name: r'memoEmbeddingsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$memoEmbeddingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MemoEmbeddingsRef = AutoDisposeFutureProviderRef<List<MemoEmbedding>>;
String _$randomMemoListHash() => r'c6ce9f7902aca1303e0e7a78bbba08949251e7de';

/// See also [RandomMemoList].
@ProviderFor(RandomMemoList)
final randomMemoListProvider = AutoDisposeAsyncNotifierProvider<
  RandomMemoList,
  List<MemoPreview>
>.internal(
  RandomMemoList.new,
  name: r'randomMemoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$randomMemoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RandomMemoList = AutoDisposeAsyncNotifier<List<MemoPreview>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
