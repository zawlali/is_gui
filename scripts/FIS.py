import numpy as np
import skfuzzy as fuzz
from skfuzzy import control as ctrl
import matplotlib.pyplot as plt
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
import logging
import json
import os
from datetime import datetime
from typing import Dict

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger("fis_api")

# Create a FastAPI instance
app = FastAPI(title="Scholar Jim FIS API", 
              description="API for Fuzzy Inference System for scholarship eligibility evaluation")

# Add CORS middleware - Configure for production
app.add_middleware(
    CORSMiddleware,
    # In production, you should restrict this to your Firebase Hosting domain
    allow_origins=["*"],  # For production: ["https://scholarjim-4d4e1.web.app", "https://scholarjim-4d4e1.firebaseapp.com"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define the request model
class ScholarshipRequest(BaseModel):
    poverty_val: float
    education_val: float
    employment_val: float

# Define the response model
class ScholarshipResponse(BaseModel):
    eligibility_score: float
    scholarship_type: str
    scholarship_type_scores: Dict[str, float]

# Create input variables
poverty = ctrl.Antecedent(np.arange(0, 61, 1), 'poverty')
education = ctrl.Antecedent(np.arange(0, 101, 1), 'education')
employment = ctrl.Antecedent(np.arange(0, 81, 1), 'employment')

# Create output variables
eligibility = ctrl.Consequent(np.arange(0, 101, 1), 'eligibility')
scholarship_type = ctrl.Consequent(np.arange(0, 101, 1), 'scholarship_type')

# Membership functions for poverty
poverty['low'] = fuzz.trimf(poverty.universe, [0, 5, 15])
poverty['medium'] = fuzz.trapmf(poverty.universe, [10, 15, 40, 50])
poverty['high'] = fuzz.trimf(poverty.universe, [40, 50, 60])

# Membership functions for education
education['below_upper'] = fuzz.trimf(education.universe, [0, 0, 33])
education['upper_second'] = fuzz.trimf(education.universe, [25, 50, 75])
education['tertiary'] = fuzz.trimf(education.universe, [67, 100, 100])

# Membership functions for employment
employment['low'] = fuzz.trimf(employment.universe, [0, 15, 20])
employment['medium'] = fuzz.trapmf(employment.universe, [18, 25, 45, 50])
employment['high'] = fuzz.trimf(employment.universe, [50, 65, 80])

# Membership functions for eligibility score
eligibility['low'] = fuzz.trimf(eligibility.universe, [0, 0, 50])
eligibility['medium'] = fuzz.trimf(eligibility.universe, [25, 50, 75])
eligibility['high'] = fuzz.trimf(eligibility.universe, [50, 100, 100])

# Membership functions for scholarship type
scholarship_type['vocational'] = fuzz.trimf(scholarship_type.universe, [0, 0, 50])
scholarship_type['academic'] = fuzz.trimf(scholarship_type.universe, [25, 50, 75])
scholarship_type['research'] = fuzz.trimf(scholarship_type.universe, [50, 100, 100])

# Rules for eligibility score
rule1_e = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['low'], eligibility['high'])
rule2_e = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['medium'], eligibility['high'])
rule3_e = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['high'], eligibility['medium'])
rule4_e = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['low'], eligibility['high'])
rule5_e = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['medium'], eligibility['medium'])
rule6_e = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['high'], eligibility['medium'])
rule7_e = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['low'], eligibility['high'])
rule8_e = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['medium'], eligibility['medium'])
rule9_e = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['high'], eligibility['medium'])
rule10_e = ctrl.Rule(poverty['medium'] & education['below_upper'] & employment['low'], eligibility['high'])
rule11_e = ctrl.Rule(poverty['medium'] & education['below_upper'] & employment['medium'], eligibility['high'])
rule12_e = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['high'], eligibility['medium'])
rule13_e = ctrl.Rule(poverty['medium'] & education['upper_second'] & employment['low'], eligibility['high'])
rule14_e = ctrl.Rule(poverty['medium'] & education['upper_second'] & employment['medium'], eligibility['medium'])
rule15_e = ctrl.Rule(poverty['medium'] & education['upper_second'] & employment['high'], eligibility['low'])
rule16_e = ctrl.Rule(poverty['medium'] & education['tertiary'] & employment['low'], eligibility['high'])
rule17_e = ctrl.Rule(poverty['medium'] & education['tertiary'] & employment['medium'], eligibility['medium'])
rule18_e = ctrl.Rule(poverty['medium'] & education['tertiary'] & employment['high'], eligibility['low'])
rule19_e = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['low'], eligibility['medium'])
rule20_e = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['medium'], eligibility['medium'])
rule21_e = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['high'], eligibility['low'])
rule22_e = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['low'], eligibility['medium'])
rule23_e = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['medium'], eligibility['medium'])
rule24_e = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['high'], eligibility['low'])
rule25_e = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['low'], eligibility['low'])
rule26_e = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['medium'], eligibility['medium'])
rule27_e = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['high'], eligibility['low'])
# Add more rules as needed

# Rules for scholarship type
rule1_s = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['low'], scholarship_type['vocational'])
rule2_s = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['medium'], scholarship_type['vocational'])
rule3_s = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['high'], scholarship_type['vocational'])
rule4_s = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['low'], scholarship_type['academic'])
rule5_s = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['medium'], scholarship_type['academic'])
rule6_s = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['high'], scholarship_type['academic'])
rule7_s = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['low'], scholarship_type['research'])
rule8_s = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['medium'], scholarship_type['research'])
rule9_s = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['high'], scholarship_type['research'])
rule10_s = ctrl.Rule(poverty['medium'] & education['below_upper'] & employment['low'], scholarship_type['vocational'])
rule11_s = ctrl.Rule(poverty['medium'] & education['below_upper'] & employment['medium'], scholarship_type['vocational'])
rule12_s = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['high'], scholarship_type['vocational'])
rule13_s = ctrl.Rule(poverty['medium'] & education['upper_second'] & employment['low'], scholarship_type['academic'])
rule14_s = ctrl.Rule(poverty['medium'] & education['upper_second'] & employment['medium'], scholarship_type['academic'])
rule15_s = ctrl.Rule(poverty['medium'] & education['upper_second'] & employment['high'], scholarship_type['academic'])
rule16_s = ctrl.Rule(poverty['medium'] & education['tertiary'] & employment['low'], scholarship_type['research'])
rule17_s = ctrl.Rule(poverty['medium'] & education['tertiary'] & employment['medium'], scholarship_type['research'])
rule18_s = ctrl.Rule(poverty['medium'] & education['tertiary'] & employment['high'], scholarship_type['research'])
rule19_s = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['low'], scholarship_type['vocational'])
rule20_s = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['medium'], scholarship_type['vocational'])
rule21_s = ctrl.Rule(poverty['low'] & education['below_upper'] & employment['high'], scholarship_type['vocational'])
rule22_s = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['low'], scholarship_type['academic'])
rule23_s = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['medium'], scholarship_type['academic'])
rule24_s = ctrl.Rule(poverty['low'] & education['upper_second'] & employment['high'], scholarship_type['academic'])
rule25_s = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['low'], scholarship_type['research'])
rule26_s = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['medium'], scholarship_type['research'])
rule27_s = ctrl.Rule(poverty['low'] & education['tertiary'] & employment['high'], scholarship_type['research'])
# Add more rules as needed

# Creating control systems
eligibility_ctrl = ctrl.ControlSystem([rule1_e, rule2_e, rule3_e, rule4_e, rule5_e, rule6_e, rule7_e, rule8_e,
                                       rule9_e, rule10_e, rule11_e, rule12_e, rule13_e, rule14_e, rule15_e, rule16_e,
                                       rule17_e, rule18_e, rule19_e, rule20_e, rule21_e, rule22_e, rule23_e, rule24_e,
                                       rule25_e, rule26_e, rule27_e])

scholarship_ctrl = ctrl.ControlSystem([rule1_s, rule2_s, rule3_s, rule4_s, rule5_s, rule6_s, rule7_s, rule8_s,
                                       rule9_s, rule10_s, rule11_s, rule12_s, rule13_s, rule14_s, rule15_s, rule16_s,
                                       rule17_s, rule18_s, rule19_s, rule20_s, rule21_s, rule22_s, rule23_s, rule24_s,
                                       rule25_s, rule26_s, rule27_s])

# Creating simulators
eligibility_simulator = ctrl.ControlSystemSimulation(eligibility_ctrl)
scholarship_simulator = ctrl.ControlSystemSimulation(scholarship_ctrl)

def evaluate_scholarship(poverty_val, education_val, employment_val):
    try:
        # Log input values
        logger.info(f"Processing evaluation with inputs: poverty={poverty_val}, education={education_val}, employment={employment_val}")
        
        # Validate input ranges
        if not (0 <= poverty_val <= 60):
            logger.warning(f"Invalid poverty value: {poverty_val}")
            raise ValueError("Poverty value must be between 0 and 60")
        if not (0 <= education_val <= 100):
            logger.warning(f"Invalid education value: {education_val}")
            raise ValueError("Education value must be between 0 and 100")
        if not (0 <= employment_val <= 80):
            logger.warning(f"Invalid employment value: {employment_val}")
            raise ValueError("Employment value must be between 0 and 80")
            
        # Evaluate eligibility score
        eligibility_simulator.input['poverty'] = poverty_val
        eligibility_simulator.input['education'] = education_val
        eligibility_simulator.input['employment'] = employment_val
        eligibility_simulator.compute()
        
        # Evaluate scholarship type
        scholarship_simulator.input['poverty'] = poverty_val
        scholarship_simulator.input['education'] = education_val
        scholarship_simulator.input['employment'] = employment_val
        scholarship_simulator.compute()

        # Get numeric output
        eligibility_score = eligibility_simulator.output['eligibility']
        scholarship_score = scholarship_simulator.output['scholarship_type']

        # Calculate membership values for each scholarship type
        scholarship_type_scores = {
            scholarship_type_name: float(fuzz.interp_membership(
                scholarship_type.universe, 
                scholarship_type[scholarship_type_name].mf, 
                scholarship_score
            ))
            for scholarship_type_name in scholarship_type.terms
        }

        # Identify best scholarship type based on highest membership value
        best_scholarship_type = max(
            scholarship_type_scores.keys(),
            key=lambda k: scholarship_type_scores[k]
        )

        result = {
            'eligibility_score': float(eligibility_score),
            'scholarship_type': best_scholarship_type,
            'scholarship_type_scores': scholarship_type_scores
        }
        
        # Log output results
        logger.info(f"Evaluation result: eligibility_score={result['eligibility_score']:.2f}, scholarship_type={result['scholarship_type']}")
        logger.info(f"Scholarship type scores: {json.dumps(scholarship_type_scores)}")
        
        return result
    except Exception as e:
        logger.error(f"Error in evaluation: {str(e)}")
        raise ValueError(f"Error evaluating scholarship: {str(e)}")

# FastAPI endpoint to evaluate scholarship
@app.post("/evaluate", response_model=ScholarshipResponse)
async def api_evaluate_scholarship(request: ScholarshipRequest):
    try:
        # Log the incoming request
        logger.info(f"Received evaluation request: {request.dict()}")
        
        result = evaluate_scholarship(
            poverty_val=request.poverty_val,
            education_val=request.education_val,
            employment_val=request.employment_val
        )
        
        # Log the response
        logger.info(f"Sending response: {result}")
        
        return result
    except ValueError as e:
        logger.error(f"Request error: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

# Optional: Endpoint to get membership function visualizations as base64 images
@app.get("/visualize/{variable}")
async def visualize_membership(variable: str):
    logger.info(f"Visualization request for variable: {variable}")
    
    import io
    import base64
    
    plt.figure(figsize=(10, 5))
    
    if variable == "poverty":
        poverty.view()
    elif variable == "education":
        education.view()
    elif variable == "employment":
        employment.view()
    elif variable == "eligibility":
        eligibility.view()
    elif variable == "scholarship_type":
        scholarship_type.view()
    else:
        logger.warning(f"Invalid visualization variable requested: {variable}")
        raise HTTPException(status_code=404, detail=f"Variable {variable} not found")
    
    # Save plot to bytes buffer
    buf = io.BytesIO()
    plt.savefig(buf, format='png')
    buf.seek(0)
    
    # Convert to base64
    img_str = base64.b64encode(buf.read()).decode('utf-8')
    plt.close()
    
    logger.info(f"Generated visualization for {variable} (image length: {len(img_str)} chars)")
    
    return {"image": img_str}

# Server startup and shutdown events
@app.on_event("startup")
async def startup_event():
    logger.info("=== FIS API Server Starting ===")
    logger.info(f"Server time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    logger.info("CORS enabled with allow_origins=*")
    logger.info("Ready to accept requests")

@app.on_event("shutdown")
async def shutdown_event():
    logger.info("=== FIS API Server Shutting Down ===")

# Health check endpoint for Cloud Run
@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Run the API server when executed directly
if __name__ == "__main__":
    # Get port from environment variable for Cloud Run
    port = int(os.environ.get("PORT", 8000))
    
    # Log startup info
    logger.info(f"Starting server on port {port}")
    
    # Run server
    uvicorn.run("FIS:app", host="0.0.0.0", port=port, log_level="info")