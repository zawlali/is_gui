import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout
import numpy as np
import pandas as pd

# Load the Excel file
file_path = "rules.xlsx"  # Ensure the file is in the same directory
xls = pd.ExcelFile(file_path)

# Load the data from the sheet
df = pd.read_excel(xls, sheet_name='Sheet1')

# Extract relevant data
df_cleaned = df.iloc[3:, [1, 2, 3, 4, 5]]  # Selecting Input1, Input2, Input3, Output1, Output2
df_cleaned.columns = ['Poverty', 'Education', 'Employment', 'Eligibility', 'Scholarship']
df_cleaned = df_cleaned.dropna().astype(float)  # Convert to numerical values

# Load the dataset
X = df_cleaned[['Poverty', 'Education', 'Employment']].values
y = df_cleaned[['Eligibility', 'Scholarship']].values

# Normalize inputs (Avoid division by zero)
X_max = np.max(X, axis=0, where=(X != 0), initial=1)  # Store max values for consistent scaling
y_max = np.max(y, axis=0, where=(y != 0), initial=1)

X = X / X_max
y = y / y_max

# Define the ANN model
# model = Sequential([
#     Dense(10, activation='relu', input_shape=(3,)),
#     Dense(8, activation='relu'),
#     Dense(2, activation='linear')  # Two output neurons
# ])

model = Sequential([
    Dense(32, activation='relu', input_shape=(3,)),  # First hidden layer with 32 neurons
    Dense(16, activation='relu'),  # Second hidden layer with 16 neurons
    Dense(8, activation='relu'),  # Third hidden layer with 8 neurons
    Dropout(0.2),  # Dropout to prevent overfitting
    Dense(2, activation='linear')  # Output layer (2 neurons for 2 outputs)
])


# Compile the model
model.compile(optimizer='adam', loss='mse', metrics=['mae'])

# Train the model
model.fit(X, y, epochs=150, batch_size=5, verbose=1)

# Save the model
model.save("ann_scholarship_model.h5")

# Function to make predictions
def predict_ann(input_data):
    input_array = np.array(input_data).reshape(1, -1) / X_max  # Use stored scaling factors
    return model.predict(input_array)
