import numpy as np
from tensorflow.keras.models import load_model
import os
from tensorflow.keras.losses import MeanSquaredError

class ANNPredictor:
    def __init__(self):
        # Load model
        model_path = os.path.join(os.path.dirname(__file__), "ann_scholarship_model.h5")
        self.model = load_model(model_path, custom_objects={'mse': MeanSquaredError()})
        
        # Normalization parameters - these should match values used during training
        self.x_min = np.array([1, 1, 1])  # Minimum values for each input feature
        self.x_max = np.array([3, 3, 3])  # Maximum values for each input feature
        self.y_min = np.array([1, 1])     # Minimum values for output
        self.y_max = np.array([3, 3])     # Maximum values for output
    
    def predict(self, poverty_rate, education_level, employment_rate):
        """
        Make predictions using the ANN model.
        
        Args:
            poverty_rate (float): Poverty rate value
            education_level (float): Education level value
            employment_rate (float): Employment rate value
            
        Returns:
            dict: Dictionary containing eligibility score and scholarship type
        """
        # Convert inputs to appropriate format and scale
        input_data = np.array([[poverty_rate, education_level, employment_rate]])
        
        # Normalize input data
        normalized_input = (input_data - self.x_min) / (self.x_max - self.x_min)
        
        # Make prediction
        prediction = self.model.predict(normalized_input)[0]
        
        # Rescale outputs
        eligibility = prediction[0] * (self.y_max[0] - self.y_min[0]) + self.y_min[0]
        scholarship = prediction[1] * (self.y_max[1] - self.y_min[1]) + self.y_min[1]
        
        # Map scholarship type to a category based on value
        scholarship_type = self._get_scholarship_type(scholarship)
        
        return {
            'eligibility_score': float(eligibility),
            'scholarship_score': float(scholarship),
            'scholarship_type': scholarship_type
        }
    
    def _get_scholarship_type(self, scholarship_value):
        """Maps numerical scholarship value to a category"""
        if scholarship_value < 1.5:
            return "Vocational Training Grant"
        elif scholarship_value < 2.5:
            return "Academic Scholarship"
        else:
            return "Research Grant"
            
    def evaluate_country(self, country_data):
        """
        Evaluate a country using ANN model.
        
        Args:
            country_data (dict): Dictionary with country parameters
            
        Returns:
            dict: Dictionary with evaluation results
        """
        # Extract parameters
        poverty_rate = country_data.get('povertyRate', 0)
        education_level = country_data.get('educationLevel', 0)
        employment_rate = country_data.get('employmentRate', 0)
        
        # Scale parameters from 0-1 range to 1-3 range for the model
        poverty_scaled = 1 + (poverty_rate * 2)  # 0-1 → 1-3
        education_scaled = 1 + (education_level * 2)  # 0-1 → 1-3
        employment_scaled = 1 + (employment_rate * 2)  # 0-1 → 1-3
        
        # Get prediction
        prediction = self.predict(poverty_scaled, education_scaled, employment_scaled)
        
        # Normalize eligibility score to 0-1 range
        eligibility_normalized = (prediction['eligibility_score'] - 1) / 2  # 1-3 → 0-1
        
        # Calculate scholarship type weights
        scholarship_types = {
            'Vocational Training Grant': 0.0,
            'Academic Scholarship': 0.0,
            'Research Grant': 0.0
        }
        
        recommended_type = prediction['scholarship_type']
        scholarship_types[recommended_type] = 0.7  # Primary weight to recommended type
        
        # Distribute remaining weights based on education level
        if recommended_type != 'Vocational Training Grant':
            scholarship_types['Vocational Training Grant'] = 0.3 * (1 - education_level)
        if recommended_type != 'Academic Scholarship':
            scholarship_types['Academic Scholarship'] = 0.3 * education_level
        if recommended_type != 'Research Grant':
            scholarship_types['Research Grant'] = 0.3 * education_level * employment_rate
            
        # Normalize weights to sum to 1
        total_weight = sum(scholarship_types.values())
        for key in scholarship_types:
            scholarship_types[key] /= total_weight
        
        return {
            'country': country_data.get('name', 'Unknown'),
            'score': eligibility_normalized,
            'scholarshipTypes': scholarship_types,
            'recommendedType': recommended_type,
            'details': {
                'povertyRate': str(poverty_rate),
                'educationLevel': str(education_level),
                'employmentRate': str(employment_rate)
            }
        }

# Create singleton instance
ann_predictor = ANNPredictor() 