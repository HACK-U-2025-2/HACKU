import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/repositories/memo_repository/in_memory_memo_repository.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/widgets/dialogs/sort_dialog.dart';

void main() {
  group('MemoRepository', () {
    late MemoRepository repository;

    setUp(() {
      repository = InMemoryMemoRepository();
    });

    test('getMemos returns empty list initially', () async {
      final memos = await repository.getMemos();
      expect(memos, isEmpty);
    });

    test('addMemo adds a memo and getMemos returns it', () async {
      await repository.addMemo('テストメモ');

      final memos = await repository.getMemos();

      expect(memos.length, 1);
      expect(memos.first.title, 'Memo 1');
      expect(memos.first.body, 'テストメモの要約');
    });

    test('getMemoById returns correct memo', () async {
      await repository.addMemo('テストメモ1');
      await repository.addMemo('テストメモ2');

      final memo = await repository.getMemoById(const MemoId(2));

      expect(memo.id, const MemoId(2));
      expect(memo.title, 'Memo 2');
      expect(memo.body, 'テストメモ2の要約');
      expect(memo.raw, 'テストメモ2');
      expect(memo.tags, isNotEmpty);
    });

    test(
      'getMemoById throws MemoNotFoundException for non-existent memo',
      () async {
        await repository.addMemo('テストメモ');

        expect(
          () => repository.getMemoById(const MemoId(99)),
          throwsA(isA<MemoNotFoundException>()),
        );
      },
    );

    test('updateMemoTitle updates title', () async {
      await repository.addMemo('テストメモ');
      await repository.updateMemoTitle(const MemoId(1), '新しいタイトル');

      final memo = await repository.getMemoById(const MemoId(1));

      expect(memo.title, '新しいタイトル');
      expect(memo.updatedAt, isNotNull);
    });

    test('updateMemoBody updates body', () async {
      await repository.addMemo('テストメモ');
      await repository.updateMemoBody(const MemoId(1), '新しい要約');

      final memo = await repository.getMemoById(const MemoId(1));

      expect(memo.body, '新しい要約');
      expect(memo.updatedAt, isNotNull);
    });

    test('updateMemoTags updates tags with existing and new tags', () async {
      await repository.addMemo('テストメモ');

      // 既存のタグと新しいタグを混ぜて更新
      await repository.updateMemoTags(const MemoId(1), ['tag1', '新しいタグ']);

      final memo = await repository.getMemoById(const MemoId(1));

      expect(memo.tags.length, 2);
      expect(memo.tags.map((tag) => tag.name), contains('tag1'));
      expect(memo.tags.map((tag) => tag.name), contains('新しいタグ'));
      expect(memo.updatedAt, isNotNull);
    });

    test('deleteMemo removes the memo', () async {
      await repository.addMemo('テストメモ1');
      await repository.addMemo('テストメモ2');

      await repository.deleteMemo(const MemoId(1));

      final memos = await repository.getMemos();

      expect(memos.length, 1);
      expect(memos.first.id, const MemoId(2));

      expect(
        () => repository.getMemoById(const MemoId(1)),
        throwsA(isA<MemoNotFoundException>()),
      );
    });

    test(
      'deleteMemo throws MemoNotFoundException for non-existent memo',
      () async {
        expect(
          () => repository.deleteMemo(const MemoId(99)),
          throwsA(isA<MemoNotFoundException>()),
        );
      },
    );

    test(
      'updateMemoTitle throws MemoNotFoundException for non-existent memo',
      () async {
        expect(
          () => repository.updateMemoTitle(const MemoId(99), '新しいタイトル'),
          throwsA(isA<MemoNotFoundException>()),
        );
      },
    );

    test(
      'updateMemoBody throws MemoNotFoundException for non-existent memo',
      () async {
        expect(
          () => repository.updateMemoBody(const MemoId(99), '新しい要約'),
          throwsA(isA<MemoNotFoundException>()),
        );
      },
    );

    test(
      'updateMemoTags throws MemoNotFoundException for non-existent memo',
      () async {
        expect(
          () => repository.updateMemoTags(const MemoId(99), ['tag1']),
          throwsA(isA<MemoNotFoundException>()),
        );
      },
    );

    test('getMemos filters by keyword', () async {
      await repository.addMemo('りんごのメモ');
      await repository.addMemo('バナナのメモ');
      await repository.addMemo('りんごとバナナ');

      final memos = await repository.getMemos(keyword: 'りんご');
      expect(memos.length, 2);
      expect(
        memos.every((m) => m.title.contains('りんご') || m.body.contains('りんご')),
        isTrue,
      );
    });

    test('getMemos filters by tag', () async {
      await repository.addMemo('メモ1');
      await repository.addMemo('メモ2');
      // タグを明示的に設定
      await repository.updateMemoTags(const MemoId(1), ['tag1']);
      await repository.updateMemoTags(const MemoId(2), ['tag2']);

      final memos = await repository.getMemos(tagNames: ['tag1']);
      // MemoPreviewにはtagsがないので、idで確認
      expect(memos.length, 1);
      expect(memos.first.id, const MemoId(1));
    });

    test('getMemos filters by keyword and tag', () async {
      await repository.addMemo('りんごのメモ'); // id:1
      await repository.addMemo('バナナのメモ'); // id:2
      await repository.updateMemoTags(const MemoId(1), ['tag1']);
      await repository.updateMemoTags(const MemoId(2), ['tag2']);

      final memos = await repository.getMemos(
        keyword: 'りんご',
        tagNames: ['tag1'],
      );
      expect(memos.length, 1);
      expect(memos.first.title, 'Memo 1');
    });

    test('getMemos sorts by createdAt asc/desc', () async {
      await repository.addMemo('A');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await repository.addMemo('B');
      final asc = await repository.getMemos(
        sort: MemoSortOption(mode: MemoSortMode.createdAt, isAsc: true),
      );
      final desc = await repository.getMemos(
        sort: MemoSortOption(mode: MemoSortMode.createdAt, isAsc: false),
      );
      expect(asc.first.title, 'Memo 1');
      expect(desc.first.title, 'Memo 2');
    });

    test('getMemos sorts by updatedAt asc/desc', () async {
      await repository.addMemo('A');
      await repository.addMemo('B');
      await repository.updateMemoTitle(const MemoId(1), 'A updated');
      final asc = await repository.getMemos(
        sort: MemoSortOption(mode: MemoSortMode.updatedAt, isAsc: true),
      );
      final desc = await repository.getMemos(
        sort: MemoSortOption(mode: MemoSortMode.updatedAt, isAsc: false),
      );
      expect(asc.first.title, anyOf('Memo 2', 'A updated'));
      expect(desc.first.title, anyOf('Memo 2', 'A updated'));
      expect(asc.first.title != desc.first.title, isTrue);
    });
  });
}
