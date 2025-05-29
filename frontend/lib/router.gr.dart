// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i8;
import 'package:frontend/models/memo.dart' as _i7;
import 'package:frontend/pages/home_page.dart' as _i1;
import 'package:frontend/pages/memo_details_page.dart' as _i2;
import 'package:frontend/pages/memo_list_view_page.dart' as _i3;
import 'package:frontend/pages/sphere_page.dart' as _i4;
import 'package:frontend/pages/tag_list_view_page.dart' as _i5;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.MemoDetailsPage]
class MemoDetailsRoute extends _i6.PageRouteInfo<MemoDetailsRouteArgs> {
  MemoDetailsRoute({
    required _i7.MemoId memoId,
    _i8.Key? key,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         MemoDetailsRoute.name,
         args: MemoDetailsRouteArgs(memoId: memoId, key: key),
         initialChildren: children,
       );

  static const String name = 'MemoDetailsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MemoDetailsRouteArgs>();
      return _i2.MemoDetailsPage(memoId: args.memoId, key: args.key);
    },
  );
}

class MemoDetailsRouteArgs {
  const MemoDetailsRouteArgs({required this.memoId, this.key});

  final _i7.MemoId memoId;

  final _i8.Key? key;

  @override
  String toString() {
    return 'MemoDetailsRouteArgs{memoId: $memoId, key: $key}';
  }
}

/// generated route for
/// [_i3.MemoListViewPage]
class MemoListViewRoute extends _i6.PageRouteInfo<MemoListViewRouteArgs> {
  MemoListViewRoute({
    _i8.Key? key,
    Set<String>? initialSelectedTagNames,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         MemoListViewRoute.name,
         args: MemoListViewRouteArgs(
           key: key,
           initialSelectedTagNames: initialSelectedTagNames,
         ),
         initialChildren: children,
       );

  static const String name = 'MemoListViewRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MemoListViewRouteArgs>(
        orElse: () => const MemoListViewRouteArgs(),
      );
      return _i3.MemoListViewPage(
        key: args.key,
        initialSelectedTagNames: args.initialSelectedTagNames,
      );
    },
  );
}

class MemoListViewRouteArgs {
  const MemoListViewRouteArgs({this.key, this.initialSelectedTagNames});

  final _i8.Key? key;

  final Set<String>? initialSelectedTagNames;

  @override
  String toString() {
    return 'MemoListViewRouteArgs{key: $key, initialSelectedTagNames: $initialSelectedTagNames}';
  }
}

/// generated route for
/// [_i4.SpherePage]
class SphereRoute extends _i6.PageRouteInfo<void> {
  const SphereRoute({List<_i6.PageRouteInfo>? children})
    : super(SphereRoute.name, initialChildren: children);

  static const String name = 'SphereRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SpherePage();
    },
  );
}

/// generated route for
/// [_i5.TagListViewPage]
class TagListViewRoute extends _i6.PageRouteInfo<void> {
  const TagListViewRoute({List<_i6.PageRouteInfo>? children})
    : super(TagListViewRoute.name, initialChildren: children);

  static const String name = 'TagListViewRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.TagListViewPage();
    },
  );
}
