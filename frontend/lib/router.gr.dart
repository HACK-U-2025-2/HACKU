// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i7;
import 'package:frontend/models/memo.dart' as _i6;
import 'package:frontend/pages/home_page.dart' as _i1;
import 'package:frontend/pages/memo_details_page.dart' as _i2;
import 'package:frontend/pages/memo_list_view_page.dart' as _i3;
import 'package:frontend/pages/sphere_page.dart' as _i4;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.MemoDetailsPage]
class MemoDetailsRoute extends _i5.PageRouteInfo<MemoDetailsRouteArgs> {
  MemoDetailsRoute({
    required _i6.MemoId memoId,
    _i7.Key? key,
    List<_i5.PageRouteInfo>? children,
  }) : super(
         MemoDetailsRoute.name,
         args: MemoDetailsRouteArgs(memoId: memoId, key: key),
         initialChildren: children,
       );

  static const String name = 'MemoDetailsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MemoDetailsRouteArgs>();
      return _i2.MemoDetailsPage(memoId: args.memoId, key: args.key);
    },
  );
}

class MemoDetailsRouteArgs {
  const MemoDetailsRouteArgs({required this.memoId, this.key});

  final _i6.MemoId memoId;

  final _i7.Key? key;

  @override
  String toString() {
    return 'MemoDetailsRouteArgs{memoId: $memoId, key: $key}';
  }
}

/// generated route for
/// [_i3.MemoListViewPage]
class MemoListViewRoute extends _i5.PageRouteInfo<void> {
  const MemoListViewRoute({List<_i5.PageRouteInfo>? children})
    : super(MemoListViewRoute.name, initialChildren: children);

  static const String name = 'MemoListViewRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.MemoListViewPage();
    },
  );
}

/// generated route for
/// [_i4.SpherePage]
class SphereRoute extends _i5.PageRouteInfo<void> {
  const SphereRoute({List<_i5.PageRouteInfo>? children})
    : super(SphereRoute.name, initialChildren: children);

  static const String name = 'SphereRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.SpherePage();
    },
  );
}
