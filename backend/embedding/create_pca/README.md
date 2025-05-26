# PCAモデル作成スクリプト

## 概要

このスクリプトは、`backend/embedding/create_pca/memo_text_sample.csv` のテキスト（先頭70件）を埋め込みベクトルに変換し、PCA（3次元）を学習して `backend/embedding/create_pca/pca_3d.pkl` に保存します。

## 使い方

1. 必要なパッケージをインストール

    ```bash
    pip install numpy scikit-learn
    ```

2. backendディレクトリで実行

    ```bash
    python -m embedding.create_pca.create_pca
    ```

3. 正常終了後、backend/embedding/create_pcaに`pca_3d.pkl` が作成されます（既に存在する場合は何もしません）。