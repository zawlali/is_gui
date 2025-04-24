from flask import Flask, request, jsonify
import json
import traceback
from datetime import datetime

# Import both models
try:
    from .FIS import fis_predictor
    from .ANN import ann_predictor
except ImportError:
    # Direct import for development
    from FIS import fis_predictor
    from ANN import ann_predictor

app = Flask(__name__)

# Set CORS headers
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response

@app.route('/health', methods=['GET'])
def health_check():
    """Simple health check endpoint"""
    return jsonify({
        'status': 'ok',
        'timestamp': datetime.now().isoformat(),
        'services': {
            'fis': 'available',
            'ann': 'available'
        }
    })

@app.route('/predict/<model_type>', methods=['POST'])
def predict(model_type):
    """
    Make a prediction using either the FIS or ANN model
    
    Args:
        model_type: Either 'fis' or 'ann'
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
            
        poverty_rate = data.get('povertyRate')
        education_level = data.get('educationLevel')
        employment_rate = data.get('employmentRate')
        
        if poverty_rate is None or education_level is None or employment_rate is None:
            return jsonify({'error': 'Missing required parameters'}), 400
            
        # Choose the appropriate model
        if model_type.lower() == 'fis':
            # FIS expects values in specific ranges
            poverty_scaled = poverty_rate * 60  # 0-1 → 0-60
            education_scaled = education_level * 100  # 0-1 → 0-100
            employment_scaled = employment_rate * 80  # 0-1 → 0-80
            
            result = fis_predictor.predict(poverty_scaled, education_scaled, employment_scaled)
        elif model_type.lower() == 'ann':
            # ANN expects values in 1-3 range
            poverty_scaled = 1 + (poverty_rate * 2)  # 0-1 → 1-3
            education_scaled = 1 + (education_level * 2)  # 0-1 → 1-3
            employment_scaled = 1 + (employment_rate * 2)  # 0-1 → 1-3
            
            result = ann_predictor.predict(poverty_scaled, education_scaled, employment_scaled)
        else:
            return jsonify({'error': f'Invalid model type: {model_type}. Must be "fis" or "ann"'}), 400
            
        # Add metadata to the result
        response = {
            'result': result,
            'model': model_type.upper(),
            'timestamp': datetime.now().isoformat(),
            'input': {
                'povertyRate': poverty_rate,
                'educationLevel': education_level,
                'employmentRate': employment_rate
            }
        }
        
        return jsonify(response)
    except Exception as e:
        app.logger.error(f"Error in prediction: {str(e)}")
        app.logger.error(traceback.format_exc())
        return jsonify({'error': str(e)}), 500

@app.route('/evaluate/countries', methods=['POST'])
def evaluate_countries():
    """Evaluate multiple countries with either model"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
            
        model_type = data.get('modelType', 'FIS').upper()
        countries = data.get('countries', [])
        ngo_id = data.get('ngoId', '1')
        
        if not countries:
            return jsonify({'error': 'No countries provided'}), 400
            
        # Select model based on type
        if model_type.upper() == 'FIS':
            predictor = fis_predictor
        elif model_type.upper() == 'ANN':
            predictor = ann_predictor
        else:
            return jsonify({'error': f'Invalid model type: {model_type}. Must be "FIS" or "ANN"'}), 400
            
        # Process each country
        results = []
        for country in countries:
            results.append(predictor.evaluate_country(country))
            
        # Sort results by score in descending order
        results.sort(key=lambda x: x['score'], reverse=True)
        
        # Create final response
        response = {
            'ngoId': ngo_id,
            'modelType': model_type,
            'generatedAt': datetime.now().isoformat(),
            'results': results
        }
        
        return jsonify(response)
    except Exception as e:
        app.logger.error(f"Error in evaluation: {str(e)}")
        app.logger.error(traceback.format_exc())
        return jsonify({'error': str(e)}), 500

# Direct country evaluation endpoints for specific models
@app.route('/evaluate/fis/countries', methods=['POST'])
def evaluate_countries_fis():
    """Evaluate multiple countries with FIS model"""
    try:
        data = request.get_json()
        data['modelType'] = 'FIS'
        return evaluate_countries()
    except Exception as e:
        app.logger.error(f"Error in FIS evaluation: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/evaluate/ann/countries', methods=['POST'])
def evaluate_countries_ann():
    """Evaluate multiple countries with ANN model"""
    try:
        data = request.get_json()
        data['modelType'] = 'ANN'
        return evaluate_countries()
    except Exception as e:
        app.logger.error(f"Error in ANN evaluation: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    print("Starting Scholar Jim AI Models Server...")
    print("Available endpoints:")
    print("  - /health")
    print("  - /predict/fis")
    print("  - /predict/ann")
    print("  - /evaluate/countries")
    print("  - /evaluate/fis/countries")
    print("  - /evaluate/ann/countries")
    app.run(host='0.0.0.0', port=5000, debug=True) 