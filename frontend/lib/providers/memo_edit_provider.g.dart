// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isEditingModeHash() => r'9e61e44b9052948afd430d96402842d984d43000';

/// See also [IsEditingMode].
@ProviderFor(IsEditingMode)
final isEditingModeProvider =
    AutoDisposeNotifierProvider<IsEditingMode, bool>.internal(
      IsEditingMode.new,
      name: r'isEditingModeProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$isEditingModeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IsEditingMode = AutoDisposeNotifier<bool>;
String _$memoTagNamesHash() => r'ddd3e3650ab31457fc5cd19e95e55f5beebb1516';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MemoTagNames
    extends BuildlessAutoDisposeNotifier<List<String>> {
  late final MemoId id;

  List<String> build(MemoId id);
}

/// See also [MemoTagNames].
@ProviderFor(MemoTagNames)
const memoTagNamesProvider = MemoTagNamesFamily();

/// See also [MemoTagNames].
class MemoTagNamesFamily extends Family<List<String>> {
  /// See also [MemoTagNames].
  const MemoTagNamesFamily();

  /// See also [MemoTagNames].
  MemoTagNamesProvider call(MemoId id) {
    return MemoTagNamesProvider(id);
  }

  @override
  MemoTagNamesProvider getProviderOverride(
    covariant MemoTagNamesProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'memoTagNamesProvider';
}

/// See also [MemoTagNames].
class MemoTagNamesProvider
    extends AutoDisposeNotifierProviderImpl<MemoTagNames, List<String>> {
  /// See also [MemoTagNames].
  MemoTagNamesProvider(MemoId id)
    : this._internal(
        () => MemoTagNames()..id = id,
        from: memoTagNamesProvider,
        name: r'memoTagNamesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$memoTagNamesHash,
        dependencies: MemoTagNamesFamily._dependencies,
        allTransitiveDependencies:
            MemoTagNamesFamily._allTransitiveDependencies,
        id: id,
      );

  MemoTagNamesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final MemoId id;

  @override
  List<String> runNotifierBuild(covariant MemoTagNames notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(MemoTagNames Function() create) {
    return ProviderOverride(
      origin: this,
      override: MemoTagNamesProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MemoTagNames, List<String>>
  createElement() {
    return _MemoTagNamesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemoTagNamesProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MemoTagNamesRef on AutoDisposeNotifierProviderRef<List<String>> {
  /// The parameter `id` of this provider.
  MemoId get id;
}

class _MemoTagNamesProviderElement
    extends AutoDisposeNotifierProviderElement<MemoTagNames, List<String>>
    with MemoTagNamesRef {
  _MemoTagNamesProviderElement(super.provider);

  @override
  MemoId get id => (origin as MemoTagNamesProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
