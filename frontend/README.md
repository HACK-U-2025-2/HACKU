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

    ```txt
    > flutter doctor
    Doctor summary (to see all details, run flutter doctor -v):
    [✓] Flutter (Channel stable, 3.29.3, on macOS 15.4.1 24E263 darwin-arm64, locale ja-JP)
    [✓] Android toolchain - develop for Android devices (Android SDK version 35.0.0)
    [✓] Xcode - develop for iOS and macOS (Xcode 16.3)
    [✓] Chrome - develop for the web
    [✓] Android Studio (version 2024.3)
    [✓] VS Code (version 1.100.0)
    [✓] Connected device (5 available)
    [✓] Network resources

    • No issues found!
    ```

- `dart pub get`の実行

### 補足

- `fvm global`を実行しなかった場合、`flutter`を`fvm flutter`、`dart`を`fvm dart`として実行する必要があります
- Android StudioやXCodeが重たい場合は、Webでの実行も可能です
  - `flutter docker`にて、Chrome環境だけあれば実行可能なはず
  - ただし、このアプリはモバイル想定のため、モバイルでの一部の機能が制限される場合があります

## 実行

### VSCodeから実行

`F5`や`Command+Shift+D`（VSCodeの左のツールバー）で実行します。

デバイスが起動している必要があります。

### `flutter run`を実行

実行するデバイスを後から選択する場合は、`flutter run`を実行します。
