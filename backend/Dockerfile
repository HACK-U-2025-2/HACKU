FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl ca-certificates \
  && ln -sf /usr/bin/python3 /usr/bin/python \
  && ln -sf /usr/bin/pip3     /usr/bin/pip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --upgrade pip && pip install -r requirements.txt

COPY .env .env

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]