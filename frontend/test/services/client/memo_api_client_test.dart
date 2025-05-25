import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/repositories/auth_repository/shared_preferences_auth_repository.dart';
import 'package:frontend/repositories/user_id_repository/value_user_id_repository.dart';
import 'package:frontend/services/client/auth_api_client.dart';
import 'package:frontend/services/client/auth_interceptor.dart';
import 'package:frontend/services/client/memo_api_client.dart';
import 'package:frontend/types/request_body.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late MemoApiClient memoClient;

  // APIのベースURL。ローカルDockerで動いていることを前提とする
  const baseUrl = 'http://localhost:8000';
  const userId = 'test_user_id';

  // サーバーのAIのモック時のレスポンスは固定
  // テストのコードも変わるため、それを管理するためのフラグ
  const useMock = true;

  setUp(() async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));

    final client = AuthApiClient(dio);
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final authRepository = SharedPreferencesAuthRepository();
    final userIdRepository = ValueUserIdRepository(userId);

    final authDio = Dio(BaseOptions(baseUrl: baseUrl));
    authDio.interceptors.add(
      JWTAuthInterceptor(
        authApiClient: client,
        authRepository: authRepository,
        userIdRepository: userIdRepository,
      ),
    );

    memoClient = MemoApiClient(authDio);
  });

  Future<Memo> createTestMemo({
    required String content,
    List<String> tags = const [],
  }) async {
    return memoClient.createMemo(
      request: MemoCreateRequest(raw: content, tagNames: tags),
    );
  }

  Future<void> deleteTestMemo(int memoId) async {
    await memoClient.deleteMemo(memoId: memoId);
  }

  group('MemoApiClient', () {
    test('Create memo', () async {
      final createdMemo = await createTestMemo(
        content: 'これはテストメモです。',
        tags: ['テスト', 'メモ'],
      );

      final fetchedMemo = await memoClient.getMemo(
        memoId: createdMemo.id.value,
      );

      expect(fetchedMemo.id.value, createdMemo.id.value);
      expect(fetchedMemo.title, createdMemo.title);
      expect(fetchedMemo.body, createdMemo.body);

      await deleteTestMemo(createdMemo.id.value);
    });

    test('Create empty tag memo', () async {
      final createdMemo = await createTestMemo(content: 'これはテストメモです。');

      final fetchedMemo = await memoClient.getMemo(
        memoId: createdMemo.id.value,
      );

      expect(fetchedMemo.id.value, createdMemo.id.value);
      expect(fetchedMemo.title, createdMemo.title);
      expect(fetchedMemo.body, createdMemo.body);

      await deleteTestMemo(createdMemo.id.value);
    });

    test('Get memo list', () async {
      final memo = await createTestMemo(
        content: 'メモ一覧テスト用',
        tags: ['テスト', 'リスト'],
      );

      final memos = await memoClient.getMemos();

      expect(memos, isNotEmpty);
      final createdMemo = memos.firstWhere(
        (m) => m.id.value == memo.id.value,
        orElse: () => throw Exception('Created memo not found in list'),
      );
      expect(createdMemo.title, memo.title);

      await deleteTestMemo(memo.id.value);
    });

    test('Update memo', () async {
      final memo = await createTestMemo(
        content: '更新テスト用メモ',
        tags: ['更新', 'テスト'],
      );

      await memoClient.updateMemoTitle(
        memoId: memo.id.value,
        request: const MemoTitleUpdateRequest(title: '更新されたタイトル'),
      );

      await memoClient.updateMemoBody(
        memoId: memo.id.value,
        request: const MemoBodyUpdateRequest(body: '更新された本文内容です。'),
      );

      await memoClient.updateMemoTags(
        memoId: memo.id.value,
        request: const MemoTagsUpdateRequest(tagNames: ['更新済み', 'テスト完了']),
      );

      final updatedMemo = await memoClient.getMemo(memoId: memo.id.value);

      expect(updatedMemo.title, '更新されたタイトル');
      expect(updatedMemo.body, '更新された本文内容です。');
      expect(updatedMemo.tags.map((t) => t.name).toList(), contains('更新済み'));
      expect(updatedMemo.tags.map((t) => t.name).toList(), contains('テスト完了'));

      await deleteTestMemo(memo.id.value);
    });

    test('Get tag list', () async {
      final memo = await createTestMemo(
        content: 'タグテスト用メモ',
        tags: ['タグ一覧', 'テスト'],
      );

      final tags = await memoClient.getTags();

      expect(tags, isNotEmpty);
      expect(tags.where((tag) => tag.name == 'タグ一覧'), isNotEmpty);

      final filteredTags = await memoClient.getTags(keyword: 'タグ一覧');
      expect(filteredTags, isNotEmpty);
      expect(filteredTags.every((tag) => tag.name.contains('タグ一覧')), isTrue);

      await deleteTestMemo(memo.id.value);
    });

    test('Search memos', () async {
      final memo = await createTestMemo(content: '検索ワード', tags: ['検索', 'テスト']);

      final searchResult = await memoClient.getMemos(
        // useMockがconstでdead_codeになるが意図的なため無視
        // ignore: dead_code
        queries: const GetMemosQuery(keyword: useMock ? 'モック' : 'ワード'),
      );

      expect(searchResult, isNotEmpty);
      expect(searchResult.any((m) => m.id.value == memo.id.value), isTrue);

      final tagSearchResult = await memoClient.getMemos(
        queries: const GetMemosQuery(tags: ['検索']),
      );
      expect(tagSearchResult, isNotEmpty);
      expect(tagSearchResult.any((m) => m.id.value == memo.id.value), isTrue);

      await deleteTestMemo(memo.id.value);
    });

    test('Get memos sorted by createdAt', () async {
      final memo1 = await createTestMemo(
        content: 'sort created 1',
        tags: ['sort'],
      );
      final memo2 = await createTestMemo(
        content: 'sort created 2',
        tags: ['sort'],
      );

      final memosAsc = await memoClient.getMemos(
        queries: const GetMemosQuery(
          tags: ['sort'],
          sort: MemoSortOrder.createdAtAsc,
        ),
      );
      final memosDesc = await memoClient.getMemos(
        queries: const GetMemosQuery(
          tags: ['sort'],
          sort: MemoSortOrder.createdAtDesc,
        ),
      );
      expect(memosAsc, isNotEmpty);
      expect(memosDesc, isNotEmpty);

      final memoIdsAsc = memosAsc.map((m) => m.id.value).toList();
      final memoIdsDesc = memosDesc.map((m) => m.id.value).toList();

      expect(
        memoIdsAsc.indexOf(memo1.id.value),
        lessThan(memoIdsAsc.indexOf(memo2.id.value)),
      );
      expect(
        memoIdsDesc.indexOf(memo1.id.value),
        greaterThan(memoIdsDesc.indexOf(memo2.id.value)),
      );

      expect(memoIdsAsc, memoIdsDesc.reversed.toList());

      await deleteTestMemo(memo1.id.value);
      await deleteTestMemo(memo2.id.value);
    });

    test('Get memos sorted by updatedAt', () async {
      final memo1 = await createTestMemo(
        content: 'sort updated 1',
        tags: ['sort'],
      );
      final memo2 = await createTestMemo(
        content: 'sort updated 2',
        tags: ['sort'],
      );
      await memoClient.updateMemoBody(
        memoId: memo1.id.value,
        request: const MemoBodyUpdateRequest(body: 'updated body 1'),
      );
      await memoClient.updateMemoBody(
        memoId: memo2.id.value,
        request: const MemoBodyUpdateRequest(body: 'updated body 2'),
      );
      final memosAsc = await memoClient.getMemos(
        queries: const GetMemosQuery(
          tags: ['sort'],
          sort: MemoSortOrder.updatedAtAsc,
        ),
      );
      final memosDesc = await memoClient.getMemos(
        queries: const GetMemosQuery(
          tags: ['sort'],
          sort: MemoSortOrder.updatedAtDesc,
        ),
      );
      expect(memosAsc, isNotEmpty);
      expect(memosDesc, isNotEmpty);

      final memoIdsAsc = memosAsc.map((m) => m.id.value).toList();
      final memoIdsDesc = memosDesc.map((m) => m.id.value).toList();
      expect(
        memoIdsAsc.indexOf(memo1.id.value),
        lessThan(memoIdsAsc.indexOf(memo2.id.value)),
      );
      expect(
        memoIdsDesc.indexOf(memo1.id.value),
        greaterThan(memoIdsDesc.indexOf(memo2.id.value)),
      );
      expect(memoIdsAsc, memoIdsDesc.reversed.toList());

      await deleteTestMemo(memo1.id.value);
      await deleteTestMemo(memo2.id.value);
    });
  });
}
