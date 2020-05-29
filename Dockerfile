FROM kaggle/python-gpu-build

# ライブラリの追加インストール
RUN pip install -U pip && \
    pip install comet_ml japanize-matplotlib

ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64"