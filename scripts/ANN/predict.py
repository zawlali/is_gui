# Missing imports
import numpy as np
from tensorflow.keras.models import load_model
import os
from tensorflow.keras.losses import MeanSquaredError

# Missing model loading
model_path = os.path.join(os.path.dirname(__file__), "ann_scholarship_model.h5")
model = load_model(model_path, custom_objects={'mse': MeanSquaredError()})

# Missing normalization parameters
# These should match the values used during training
x_min = np.array([1, 1, 1])  # Minimum values for each input feature
x_max = np.array([3, 3, 3])  # Maximum values for each input feature
y_min = np.array([1, 1])     # Minimum values for output
y_max = np.array([3, 3])     # Maximum values for output

# Missing predict_ann function
def predict_ann(input_data):
    # Convert to numpy array
    input_data = np.array([input_data])
    
    # Normalize input data
    normalized_input = (input_data - x_min) / (x_max - x_min)
    
    # Make prediction
    prediction = model.predict(normalized_input)[0]
    
    return prediction

# Existing code
new_input = [1, 2, 1]
prediction = predict_ann(new_input)
# Fix the rescaling
eligibility = prediction[0] * (y_max[0] - y_min[0]) + y_min[0]
scholarship = prediction[1] * (y_max[1] - y_min[1]) + y_min[1]

print(f"Predicted Eligibility Score: {eligibility:.2f}")
print(f"Predicted Scholarship Type: {scholarship:.2f}")

# Output:2.40 ( ELigibility)
# Output: 2.09 ( Scholarship type)