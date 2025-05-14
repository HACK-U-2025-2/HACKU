# backend

## Getting Started

このプロジェクトでは、`Docker`を使用して、バックエンドの開発環境を構築します。

### 前提条件

- Docker Desktopがインストール・起動済みであること

- docker-compose コマンドが使用可能であること

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

### サーバへのアクセス方法
- APIサーバ: http://localhost:8000
- API docs: http://localhost:8000/docs
- DBサーバ: localhost:15432 (username: hacku, password: password, dbname: hacku_db)
  - GUI クライアントやpsqlを用いてアクセス

### サーバの停止方法
- DBの内容を残したい場合
```bash
    docker-compose down
```
- DBの内容を削除したい場合
```bash
    docker-compose down -v
```