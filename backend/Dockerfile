FROM python:3.13-alpine

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --upgrade pip && pip install -r requirements.txt

COPY .env .env

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]