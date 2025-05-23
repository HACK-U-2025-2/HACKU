import 'package:dio/dio.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/services/client/auth_interceptor.dart';
import 'package:frontend/types/request_body.dart';
import 'package:retrofit/retrofit.dart';

part 'memo_api_client.g.dart';

@RestApi()
abstract class MemoApiClient {
  factory MemoApiClient(Dio dio) {
    assert(
      dio.interceptors.any((i) => i is AuthInterceptor),
      'MemoApiClient must be created with AuthInterceptor',
    );
    return _MemoApiClient(dio);
  }

  /// メモ一覧を取得
  @GET('/memos/')
  Future<List<MemoPreview>> getMemos({
    @Query('keyword') String? keyword,
    @Query('tags') List<String>? tags,
    @Query('sort') String? sort,
  });

  /// 新たなメモを投稿
  @POST('/memos/')
  Future<Memo> createMemo({@Body() required CreateMemoRequest request});

  /// 指定されたメモの詳細情報を取得
  @GET('/memos/{memo_id}')
  Future<Memo> getMemo({@Path('memo_id') required int memoId});

  /// メモの文章修正
  @PATCH('/memos/{memo_id}/body')
  Future<void> updateMemoBody({
    @Path('memo_id') required int memoId,
    @Body() required UpdateBodyRequest request,
  });

  /// メモのタイトル修正
  @PATCH('/memos/{memo_id}/title')
  Future<void> updateMemoTitle({
    @Path('memo_id') required int memoId,
    @Body() required UpdateTitleRequest request,
  });

  /// メモのタグ修正
  @PATCH('/memos/{memo_id}/tags')
  Future<void> updateMemoTags({
    @Path('memo_id') required int memoId,
    @Body() required UpdateTagsRequest request,
  });

  /// メモを削除
  @DELETE('/memos/{memo_id}')
  Future<void> deleteMemo({@Path('memo_id') required int memoId});

  /// ユーザが使用したタグ一覧を取得
  @GET('/tags')
  Future<List<Tag>> getTags({@Query('keyword') String? keyword});
}
