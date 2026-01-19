# Used slim to reduce size of the app
FROM python:3.9-slim

WORKDIR /app
COPY src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/app.py .

# Security Best Practice: Run with a user that is not root
RUN useradd -m myuser && chown -R myuser /app
USER myuser

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]