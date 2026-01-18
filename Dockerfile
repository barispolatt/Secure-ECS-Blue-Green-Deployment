# Used slim to reduce size of the app
FROM python:3.9-slim

WORKDIR /src
COPY requirements.txt.
RUN pip install --no-cache-dir -r requirements.txt
COPY src/.

# Security Best Practice: Run with a user that is not root
RUN useradd -m myuser
USER myuser

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]