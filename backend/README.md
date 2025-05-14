# backend

## Getting Started

このプロジェクトでは、`Docker`を使用して、バックエンドの開発環境を構築します。

### 前提条件

- Docker Desktopがインストール・起動済みであること

- docker-compose コマンドが使用可能であること

- Cloudflaredがインストール済みであること

### 実行方法
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

### Cloudflare Tunnelの実行
```bash
    cloudflared tunnel --url http://localhost:8000
```

(ドメイン登録をしていないので、起動のたびにエンドポイントが変更されます)

### サーバへのアクセス方法
- APIサーバ: http://localhost:8000
- API docs: http://localhost:8000/docs
- DBサーバ: localhost:15432 (username: hacku, password: password, dbname: hacku_db)
  - GUI クライアントやpsqlを用いてアクセス
- pgadmin: http://localhost:181 (email:  fastapi@example.com, password: password)

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