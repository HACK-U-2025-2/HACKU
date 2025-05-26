import os
import pickle

import numpy as np
from embedding.embedding import get_embedding
from sklearn.decomposition import PCA

PCA_PATH = "embedding\create_pca\pca_3d.pkl"

# ① memo_text_sample.csvの先頭70行を読み込む（カラム名なし）
with open("embedding\create_pca\memo_text_sample.csv", "r", encoding="utf-8-sig") as f:
    texts = [line.strip() for line in f][:70]

# ② 70件をembeddingし、リスト化
embeddings = []
for text in texts:
    emb = get_embedding(text)  # 埋め込み次元 1024次元
    embeddings.append(emb)

# ③ ndarray化
emb_array = np.stack(embeddings)  # shape: (70, 埋め込み次元)

# ④ pca_3d.pklがなければPCAをfitして保存
if not os.path.exists(PCA_PATH):
    pca = PCA(n_components=3, random_state=0).fit(emb_array)
    with open(PCA_PATH, "wb") as f:
        pickle.dump(pca, f)
