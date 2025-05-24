import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/repositories/auth_repository/auth_repository.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/services/client/memo_api_client.dart';

class ApiClientMemoRepository implements MemoRepository {
  ApiClientMemoRepository(this._memoApiClient);

  final MemoApiClient _memoApiClient;

  @override
  Future<List<MemoPreview>> getMemos({
    String? keyword,
    List<String>? tagNames,
    MemoSort? sort,
  }) async {
    try {
      return await _memoApiClient.getMemos(
        queries: GetMemosQuery(keyword: keyword, tags: tagNames, sort: sort),
      );
    } on DioException catch (e) {
      throw _handleDioException(e, null);
    }
  }

  @override
  Future<Memo> getMemoById(MemoId id) async {
    try {
      return await _memoApiClient.getMemo(memoId: id.value);
    } on DioException catch (e) {
      throw _handleDioException(e, id);
    }
  }

  @override
  Future<Memo> addMemo(String rawMemo) async {
    final request = CreateMemoRequest(
      raw: rawMemo,
      // tagNames: [],
    );
    try {
      return await _memoApiClient.createMemo(request: request);
    } on DioException catch (e) {
      throw _handleDioException(e, null);
    }
  }

  @override
  Future<void> updateMemoTitle(MemoId id, String newTitle) async {
    try {
      final request = UpdateTitleRequest(title: newTitle);
      await _memoApiClient.updateMemoTitle(memoId: id.value, request: request);
    } on DioException catch (e) {
      throw _handleDioException(e, id);
    }
  }

  @override
  Future<void> updateMemoBody(MemoId id, String newBody) async {
    try {
      final request = UpdateBodyRequest(body: newBody);
      await _memoApiClient.updateMemoBody(memoId: id.value, request: request);
    } on DioException catch (e) {
      throw _handleDioException(e, id);
    }
  }

  @override
  Future<void> updateMemoTags(MemoId id, List<String> newTags) async {
    try {
      final request = UpdateTagsRequest(tagNames: newTags);
      await _memoApiClient.updateMemoTags(memoId: id.value, request: request);
    } on DioException catch (e) {
      throw _handleDioException(e, id);
    }
  }

  @override
  Future<void> deleteMemo(MemoId id) async {
    try {
      await _memoApiClient.deleteMemo(memoId: id.value);
    } on DioException catch (e) {
      throw _handleDioException(e, id);
    }
  }
}

Exception _handleDioException(DioException e, MemoId? id) {
  switch (e.response?.statusCode) {
    case 401:
      return UnauthenticatedException();
    case 404 when id != null:
      return MemoNotFoundException(id);
    case 422:
      return MemoValidationException(e);
    case 500:
      return MemoServerException(e);
    default:
      debugPrint('Unhandled DioException: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Request: ${e.requestOptions.path}');
      debugPrint('Status code: ${e.response?.statusCode}');
      return MemoUnknownException(e);
  }
}
