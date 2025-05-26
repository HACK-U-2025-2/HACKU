// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memoHash() => r'0d0bc51cfb7d6eec9899d681ad516f2e26b061f2';

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

/// See also [memo].
@ProviderFor(memo)
const memoProvider = MemoFamily();

/// See also [memo].
class MemoFamily extends Family<AsyncValue<Memo>> {
  /// See also [memo].
  const MemoFamily();

  /// See also [memo].
  MemoProvider call(MemoId id) {
    return MemoProvider(id);
  }

  @override
  MemoProvider getProviderOverride(covariant MemoProvider provider) {
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
  String? get name => r'memoProvider';
}

/// See also [memo].
class MemoProvider extends AutoDisposeFutureProvider<Memo> {
  /// See also [memo].
  MemoProvider(MemoId id)
    : this._internal(
        (ref) => memo(ref as MemoRef, id),
        from: memoProvider,
        name: r'memoProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$memoHash,
        dependencies: MemoFamily._dependencies,
        allTransitiveDependencies: MemoFamily._allTransitiveDependencies,
        id: id,
      );

  MemoProvider._internal(
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
  Override overrideWith(FutureOr<Memo> Function(MemoRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: MemoProvider._internal(
        (ref) => create(ref as MemoRef),
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
  AutoDisposeFutureProviderElement<Memo> createElement() {
    return _MemoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemoProvider && other.id == id;
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
mixin MemoRef on AutoDisposeFutureProviderRef<Memo> {
  /// The parameter `id` of this provider.
  MemoId get id;
}

class _MemoProviderElement extends AutoDisposeFutureProviderElement<Memo>
    with MemoRef {
  _MemoProviderElement(super.provider);

  @override
  MemoId get id => (origin as MemoProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
