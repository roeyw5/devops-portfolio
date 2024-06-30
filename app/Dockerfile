FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src ./src

ENV PYTHONPATH=/app/src

EXPOSE 5000

#RUN adduser -D roey
#USER roey

ENTRYPOINT ["python", "src/main.py"]
