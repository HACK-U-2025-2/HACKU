# backend

## Getting Started

このプロジェクトでは、`Docker`を使用して、バックエンドの開発環境を構築します。

### 前提条件

- Docker Desktopがインストール・起動済みであること

- docker-compose コマンドが使用可能であること

- Cloudflaredがインストール済みであること

### 実行方法(GPU環境)
- 初回実行時
```bash
    cd backend
    docker-compose up -d --build
```
- ２回目以降
```bash
    cd backend
    docker-compose up -d
```

### 実行方法(CPU環境)
- 初回実行時
```bash
    cd backend
    docker-compose -f docker-compose.yml up -d --build
```
- ２回目以降
```bash
    cd backend
    docker-compose -f docker-compose.yml up -d
```

### データベースの更新(テーブル変更時)
- サーバを起動した状態で以下を実行
```bash
    docker compose exec db psql -U hacku -d hacku_db
    CREATE EXTENSION IF NOT EXISTS vector;
    \q
    docker exec -it backend-backend-1 sh  
    alembic upgrade head
```

### Cloudflare Tunnelの実行
```bash
    cloudflared tunnel --url http://localhost:8000
```

(ドメイン登録をしていないので、起動のたびにエンドポイントが変更されます)

### テストコードの実行
```bash
    cd backend
    docker-compose -f docker-compose.yml run --rm backend pytest -s
```

### サーバへのアクセス方法
- APIサーバ: http://localhost:8000
- API docs: http://localhost:8000/docs
- DBサーバ: localhost:5432 (username: hacku, password: password, dbname: hacku_db)
  - GUI クライアントやpsqlを用いてアクセス
- pgadmin: http://localhost:81 (email:  fastapi@example.com, password: password)

### docs上で認証が必要なエンドポイントを確認する方法
- POST /authから、確認したいuser_idを入力し、レスポンスを生成
- レスポンスから"access_token"に該当する箇所の文字列を取得
- 右上Authorizeボタンを押下
- valueに先ほどの文字列を入れ、Authorizeボタンを押す
- これにより、指定したuser_idとして他エンドポイントを参照可能になる

### pgadminの初期設定
- pgadminにアクセス
- 新しいサーバを追加を選択
  - 名前: hacku_db
  - ホスト名: db
  - 管理用データベース: postgres
  - ユーザ名: hacku
  - パスワード: password
- これによりテーブルがpgadmin上で確認できるようになる

### DB内のテーブル確認
- pgadminにアクセス
- Servers -> hacku_db -> データベース -> hacku_db -> スキーマ -> public -> テーブル

### サーバの停止方法
- DBの内容を残したい場合
```bash
    docker-compose down
```
- DBの内容を削除したい場合
```bash
    docker-compose down -v
```