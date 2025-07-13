# ---------- Stage 1: Build ----------
    FROM python:3.12-slim AS builder

    # Set environment variables
    ENV PYTHONDONTWRITEBYTECODE 1
    ENV PYTHONUNBUFFERED 1
    
    # Create working directory
    WORKDIR /app
    
    # Install build dependencies
    RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential gcc && \
        rm -rf /var/lib/apt/lists/*
    
    # Install Python dependencies
    COPY requirements.txt .
    RUN pip install --upgrade pip
    RUN pip install --prefix=/install -r requirements.txt
    
    # ---------- Stage 2: Run ----------
    FROM python:3.12-slim
    
    # Set environment variables
    ENV PYTHONDONTWRITEBYTECODE 1
    ENV PYTHONUNBUFFERED 1
    
    # Create working directory
    WORKDIR /app
    
    # Copy installed dependencies from builder
    COPY --from=builder /install /usr/local
    
    # Copy application source
    COPY . /app
    
    # Allow environment variable injection
    ENV FLASK_ENV=production
    ENV FLASK_APP=run.py
    
    # Expose port
    EXPOSE 5000
    
    # Start the app
    CMD ["flask", "run", "--host=0.0.0.0"]
    