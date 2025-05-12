# frontend

## Getting Started

このプロジェクトでは、`fvm`を使用して、フロントエンドの開発環境を構築します。

Dockerを利用する方法については詳しくないため省略します。

- `fvm`のインストール（[Installation – FVM](https://fvm.app/documentation/getting-started/installation)）
  - MacOS

    ```bash
    brew tap leoafarias/fvm
    brew install fvm
    ```

  - Windows

    ```bash
    choco install fvm
    ```

- `fvm global {version}`の実行
  - 例）`fvm global 3.29.3`
  - [グローバルバージョンの設定 – FVM](https://fvm.app/documentation/guides/global-configuration)

- `cd frontend`（カレントディレクトリをfrontendフォルダに設定）
- `fvm use`の実行
  - .fvmrcファイルに記載されているバージョンを使用するためのコマンド
- `flutter doctor`の実行
  - もし、セットアップが必要なものがあれば、指示に従ってセットアップを行う
- `dart pub get`の実行

## 実行

### VSCodeから実行

`F5`で実行します。

デバイスが起動している必要があります。

### `flutter run`を実行

実行するデバイスを後から選択する場合は、`flutter run`を実行します。
