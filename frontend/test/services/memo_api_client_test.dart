import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/services/memo_api_client.dart';
import 'package:frontend/types/request_body.dart';

void main() {
  late MemoApiClient client;
  late Dio dio;
  late String token;

  // APIのベースURL。ローカルDockerで動いていることを前提とする
  const baseUrl = 'http://localhost:8000';

  setUp(() async {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    client = MemoApiClient(dio);

    final authResponse = await client.getAuthToken(userId: 'test-user');
    token = authResponse.token;
  });

  Future<Memo> createMemo({
    required String content,
    required List<String> tags,
  }) async {
    return client.createMemo(
      token: token,
      request: CreateMemoRequest(raw: content, tagNames: tags),
    );
  }

  Future<void> cleanupMemo(int memoId) async {
    await client.deleteMemo(memoId: memoId, token: token);
  }

  group('MemoApiClient', () {
    test('Get auth token', () async {
      final response = await client.getAuthToken(userId: 'test-user');
      expect(response.token, isNotEmpty);
    });

    test('Create and get memo', () async {
      final createdMemo = await createMemo(
        content: 'これはテストメモです。',
        tags: ['テスト', 'メモ'],
      );

      final fetchedMemo = await client.getMemo(
        memoId: createdMemo.id.value,
        token: token,
      );

      expect(fetchedMemo.id.value, createdMemo.id.value);
      expect(fetchedMemo.title, createdMemo.title);
      expect(fetchedMemo.body, createdMemo.body);

      await cleanupMemo(createdMemo.id.value);
    });

    test('Get memo list', () async {
      final memo = await createMemo(content: 'メモ一覧テスト用', tags: ['テスト', 'リスト']);

      final memos = await client.getMemos(token: token);

      expect(memos, isNotEmpty);
      final createdMemo = memos.firstWhere(
        (m) => m.id.value == memo.id.value,
        orElse: () => throw Exception('Created memo not found in list'),
      );
      expect(createdMemo.title, memo.title);

      await cleanupMemo(memo.id.value);
    });

    test('Update memo', () async {
      final memo = await createMemo(content: '更新テスト用メモ', tags: ['更新', 'テスト']);

      await client.updateMemoTitle(
        memoId: memo.id.value,
        token: token,
        request: const UpdateTitleRequest(title: '更新されたタイトル'),
      );

      await client.updateMemoBody(
        memoId: memo.id.value,
        token: token,
        request: const UpdateBodyRequest(body: '更新された本文内容です。'),
      );

      await client.updateMemoTags(
        memoId: memo.id.value,
        token: token,
        request: const UpdateTagsRequest(tagNames: ['更新済み', 'テスト完了']),
      );

      final updatedMemo = await client.getMemo(
        memoId: memo.id.value,
        token: token,
      );

      expect(updatedMemo.title, '更新されたタイトル');
      expect(updatedMemo.body, '更新された本文内容です。');
      expect(updatedMemo.tags.map((t) => t.name).toList(), contains('更新済み'));
      expect(updatedMemo.tags.map((t) => t.name).toList(), contains('テスト完了'));

      await cleanupMemo(memo.id.value);
    });

    test('Get tag list', () async {
      final memo = await createMemo(content: 'タグテスト用メモ', tags: ['タグ一覧', 'テスト']);

      final tags = await client.getTags(token: token);

      expect(tags, isNotEmpty);
      expect(tags.where((tag) => tag.name == 'タグ一覧'), isNotEmpty);

      final filteredTags = await client.getTags(token: token, keyword: 'タグ一覧');
      expect(filteredTags, isNotEmpty);
      expect(filteredTags.every((tag) => tag.name.contains('タグ一覧')), isTrue);

      await cleanupMemo(memo.id.value);
    });

    test('Search memos', () async {
      final memo = await createMemo(content: '検索ワード', tags: ['検索', 'テスト']);

      final searchResult = await client.getMemos(token: token, keyword: 'ワード');

      expect(searchResult, isNotEmpty);
      expect(searchResult.any((m) => m.id.value == memo.id.value), isTrue);

      final tagSearchResult = await client.getMemos(token: token, tags: ['検索']);
      expect(tagSearchResult, isNotEmpty);
      expect(tagSearchResult.any((m) => m.id.value == memo.id.value), isTrue);

      await cleanupMemo(memo.id.value);
    });
  });
}
