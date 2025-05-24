import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/services/client/memo_api_client.dart';
import 'package:frontend/types/request_body.dart';

// TODO(tyPhoon-collab): 例外処理をしっかり実装する
class ApiClientMemoRepository implements MemoRepository {
  ApiClientMemoRepository(this._memoApiClient);

  final MemoApiClient _memoApiClient;

  @override
  Future<List<MemoPreview>> getMemos() async {
    return _memoApiClient.getMemos();
  }

  @override
  Future<Memo> getMemoById(MemoId id) async {
    try {
      return await _memoApiClient.getMemo(memoId: id.value);
    } on Exception catch (e) {
      throw MemoUnknownException(e);
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
    } on Exception catch (e) {
      throw MemoUnknownException(e);
    }
  }

  @override
  Future<void> updateMemoTitle(MemoId id, String newTitle) async {
    try {
      final request = UpdateTitleRequest(title: newTitle);
      await _memoApiClient.updateMemoTitle(memoId: id.value, request: request);
    } on Exception catch (e) {
      throw MemoUnknownException(e);
    }
  }

  @override
  Future<void> updateMemoBody(MemoId id, String newBody) async {
    try {
      final request = UpdateBodyRequest(body: newBody);
      await _memoApiClient.updateMemoBody(memoId: id.value, request: request);
    } on Exception catch (e) {
      throw MemoUnknownException(e);
    }
  }

  @override
  Future<void> updateMemoTags(MemoId id, List<String> newTags) async {
    try {
      final request = UpdateTagsRequest(tagNames: newTags);
      await _memoApiClient.updateMemoTags(memoId: id.value, request: request);
    } on Exception catch (e) {
      throw MemoUnknownException(e);
    }
  }

  @override
  Future<void> deleteMemo(MemoId id) async {
    try {
      await _memoApiClient.deleteMemo(memoId: id.value);
    } on Exception catch (e) {
      throw MemoUnknownException(e);
    }
  }
}
