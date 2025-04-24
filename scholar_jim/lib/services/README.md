# Scholar Jim AI Models Server

This is a unified web server for the Scholar Jim scholarship management application that provides endpoints for both Artificial Neural Network (ANN) and Fuzzy Inference System (FIS) models.

## Overview

The server provides endpoints to:
- Evaluate countries for scholarship eligibility
- Make predictions using either the ANN or FIS model
- Check server health

## Files

- `web_server.py`: The main Flask web server
- `ANN.py`: The Artificial Neural Network model implementation
- `FIS.py`: The Fuzzy Inference System model implementation

## Requirements

- Python 3.8+
- Flask
- TensorFlow
- scikit-fuzzy
- NumPy

## Installation

1. Install the required dependencies:
```bash
pip install flask tensorflow scikit-fuzzy numpy
```

2. Make sure the `ann_scholarship_model.h5` model file is available in the same directory.

## Running the Server

Run the web server:
```bash
python web_server.py
```

The server will start at http://localhost:5000

## API Endpoints

### Health Check
```
GET /health
```

Example response:
```json
{
  "status": "ok",
  "timestamp": "2023-08-22T15:30:45.123456",
  "services": {
    "fis": "available",
    "ann": "available"
  }
}
```

### Individual Prediction
```
POST /predict/<model_type>
```
Where `<model_type>` is either `fis` or `ann`.

Request body:
```json
{
  "povertyRate": 0.35,
  "educationLevel": 0.65,
  "employmentRate": 0.55
}
```

Example response:
```json
{
  "result": {
    "eligibility_score": 0.82,
    "scholarship_type": "Academic Scholarship"
  },
  "model": "FIS",
  "timestamp": "2023-08-22T15:31:25.123456",
  "input": {
    "povertyRate": 0.35,
    "educationLevel": 0.65,
    "employmentRate": 0.55
  }
}
```

### Country Evaluation
```
POST /evaluate/countries
```

Request body:
```json
{
  "ngoId": "2",
  "modelType": "ANN",
  "countries": [
    {
      "name": "Kenya",
      "povertyRate": 0.35,
      "educationLevel": 0.65,
      "employmentRate": 0.55
    },
    {
      "name": "Ghana",
      "povertyRate": 0.28,
      "educationLevel": 0.72,
      "employmentRate": 0.60
    }
  ]
}
```

Example response:
```json
{
  "ngoId": "2",
  "modelType": "ANN",
  "generatedAt": "2023-08-22T15:32:15.123456",
  "results": [
    {
      "country": "Ghana",
      "score": 0.85,
      "scholarshipTypes": {
        "Vocational Training Grant": 0.1,
        "Academic Scholarship": 0.3,
        "Research Grant": 0.6
      },
      "recommendedType": "Research Grant",
      "details": {
        "povertyRate": "0.28",
        "educationLevel": "0.72",
        "employmentRate": "0.6"
      }
    },
    {
      "country": "Kenya",
      "score": 0.75,
      "scholarshipTypes": {
        "Vocational Training Grant": 0.2,
        "Academic Scholarship": 0.5,
        "Research Grant": 0.3
      },
      "recommendedType": "Academic Scholarship",
      "details": {
        "povertyRate": "0.35",
        "educationLevel": "0.65",
        "employmentRate": "0.55"
      }
    }
  ]
}
```

## Model-Specific Endpoints

For convenience, there are also direct endpoints for each model:

- `POST /evaluate/fis/countries` - Evaluate countries using the FIS model
- `POST /evaluate/ann/countries` - Evaluate countries using the ANN model

These accept the same parameters as the `/evaluate/countries` endpoint, but you don't need to specify the `modelType` parameter. 