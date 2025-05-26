import pickle

import numpy as np

PCA_PATH = "embedding/create_pca/pca_3d.pkl"


def embedding_to_3d_unit(embedding: list) -> list:
    """
    embedding(長さ1024など)をPCA(3D)で写像し、単位球面に正規化して返す
    """
    # pca_3d.pklをロード
    with open(PCA_PATH, "rb") as f:
        pca = pickle.load(f)
    vec_3d = pca.transform([embedding])  # shape: (1, 3)
    vec_3d_norm = vec_3d / np.linalg.norm(vec_3d, axis=1, keepdims=True)
    return vec_3d_norm[0].tolist()
