FROM python:3.9-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY FIS.py .

# Set environment variables
ENV PORT=8080

# Expose the port
EXPOSE 8080

# Run the FastAPI server
CMD ["uvicorn", "FIS:app", "--host", "0.0.0.0", "--port", "8080"] 