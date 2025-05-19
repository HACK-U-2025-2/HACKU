import 'package:frontend/models/memo.dart';
import 'package:frontend/models/tag.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_provider.g.dart';

@riverpod
Future<Memo> memo(Ref ref, MemoId id) async {
  return Memo(
    id: const MemoId(1),
    title: '仮タイトル',
    body: '''
## プログラミング学習の始め方

プログラミング学習を始めるためのステップをいくつかご紹介します。

1.  **目標設定:** なぜプログラミングを学びたいのか、具体的な目標を決めましょう。（例: Webサイト作成、データ分析、ゲーム開発など）
2.  **言語選択:** 目標に合ったプログラミング言語を選びます。初心者にはPythonなどがおすすめです。
3.  **学習リソース:** オンラインチュートリアル、公式ドキュメント、書籍などを活用します。
4.  **実践:** 小さなプログラムを実際に書いて、動かしてみることが重要です。

### Pythonの簡単なコード例

```python
# Hello Worldを表示するコード
print("Hello, World!")
```

このコードを実行すると、「Hello, World!」と出力されます。

-----

ご不明な点がございましたら、お気軽にご質問ください。''',
    raw: 'あいうえお',
    tags: const [
      Tag(id: TagId(1), name: '仮タグ1'),
      Tag(id: TagId(2), name: '仮タグ2'),
    ],
    createdAt: DateTime.now(),
  );
}
