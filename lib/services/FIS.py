import numpy as np
import skfuzzy as fuzz
from skfuzzy import control as ctrl

class FuzzyInferenceSystem:
    def __init__(self):
        # Create input variables
        self.poverty = ctrl.Antecedent(np.arange(0, 61, 1), 'poverty')
        self.education = ctrl.Antecedent(np.arange(0, 101, 1), 'education')
        self.employment = ctrl.Antecedent(np.arange(0, 81, 1), 'employment')

        # Create output variables
        self.eligibility = ctrl.Consequent(np.arange(0, 101, 1), 'eligibility')
        self.scholarship_type = ctrl.Consequent(np.arange(0, 101, 1), 'scholarship_type')

        # Setup membership functions
        self._setup_membership_functions()
        
        # Setup rules
        self._setup_rules()
        
        # Create control systems
        self.eligibility_ctrl = ctrl.ControlSystem(self.eligibility_rules)
        self.scholarship_ctrl = ctrl.ControlSystem(self.scholarship_rules)
        
        # Create simulators
        self.eligibility_simulator = ctrl.ControlSystemSimulation(self.eligibility_ctrl)
        self.scholarship_simulator = ctrl.ControlSystemSimulation(self.scholarship_ctrl)
    
    def _setup_membership_functions(self):
        # Membership functions for poverty
        self.poverty['low'] = fuzz.trimf(self.poverty.universe, [0, 5, 15])
        self.poverty['medium'] = fuzz.trapmf(self.poverty.universe, [10, 15, 40, 50])
        self.poverty['high'] = fuzz.trimf(self.poverty.universe, [40, 50, 60])

        # Membership functions for education
        self.education['below_upper'] = fuzz.trimf(self.education.universe, [0, 0, 33])
        self.education['upper_second'] = fuzz.trimf(self.education.universe, [25, 50, 75])
        self.education['tertiary'] = fuzz.trimf(self.education.universe, [67, 100, 100])

        # Membership functions for employment
        self.employment['low'] = fuzz.trimf(self.employment.universe, [0, 15, 20])
        self.employment['medium'] = fuzz.trapmf(self.employment.universe, [18, 25, 45, 50])
        self.employment['high'] = fuzz.trimf(self.employment.universe, [50, 65, 80])

        # Membership functions for eligibility score
        self.eligibility['low'] = fuzz.trimf(self.eligibility.universe, [0, 0, 50])
        self.eligibility['medium'] = fuzz.trimf(self.eligibility.universe, [25, 50, 75])
        self.eligibility['high'] = fuzz.trimf(self.eligibility.universe, [50, 100, 100])

        # Membership functions for scholarship type
        self.scholarship_type['vocational'] = fuzz.trimf(self.scholarship_type.universe, [0, 0, 50])
        self.scholarship_type['academic'] = fuzz.trimf(self.scholarship_type.universe, [25, 50, 75])
        self.scholarship_type['research'] = fuzz.trimf(self.scholarship_type.universe, [50, 100, 100])
    
    def _setup_rules(self):
        # Rules for eligibility score
        self.eligibility_rules = [
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['low'], self.eligibility['high']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['medium'], self.eligibility['high']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['high'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['low'], self.eligibility['high']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['medium'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['high'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['low'], self.eligibility['high']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['medium'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['high'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['medium'] & self.education['below_upper'] & self.employment['low'], self.eligibility['high']),
            ctrl.Rule(self.poverty['medium'] & self.education['below_upper'] & self.employment['medium'], self.eligibility['high']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['high'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['medium'] & self.education['upper_second'] & self.employment['low'], self.eligibility['high']),
            ctrl.Rule(self.poverty['medium'] & self.education['upper_second'] & self.employment['medium'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['medium'] & self.education['upper_second'] & self.employment['high'], self.eligibility['low']),
            ctrl.Rule(self.poverty['medium'] & self.education['tertiary'] & self.employment['low'], self.eligibility['high']),
            ctrl.Rule(self.poverty['medium'] & self.education['tertiary'] & self.employment['medium'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['medium'] & self.education['tertiary'] & self.employment['high'], self.eligibility['low']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['low'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['medium'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['high'], self.eligibility['low']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['low'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['medium'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['high'], self.eligibility['low']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['low'], self.eligibility['low']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['medium'], self.eligibility['medium']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['high'], self.eligibility['low']),
        ]

        # Rules for scholarship type
        self.scholarship_rules = [
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['low'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['medium'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['high'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['low'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['medium'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['high'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['low'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['medium'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['high'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['medium'] & self.education['below_upper'] & self.employment['low'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['medium'] & self.education['below_upper'] & self.employment['medium'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['high'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['medium'] & self.education['upper_second'] & self.employment['low'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['medium'] & self.education['upper_second'] & self.employment['medium'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['medium'] & self.education['upper_second'] & self.employment['high'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['medium'] & self.education['tertiary'] & self.employment['low'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['medium'] & self.education['tertiary'] & self.employment['medium'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['medium'] & self.education['tertiary'] & self.employment['high'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['low'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['medium'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['low'] & self.education['below_upper'] & self.employment['high'], self.scholarship_type['vocational']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['low'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['medium'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['low'] & self.education['upper_second'] & self.employment['high'], self.scholarship_type['academic']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['low'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['medium'], self.scholarship_type['research']),
            ctrl.Rule(self.poverty['low'] & self.education['tertiary'] & self.employment['high'], self.scholarship_type['research']),
        ]
    
    def predict(self, poverty_val, education_val, employment_val):
        """
        Evaluate using the fuzzy system.
        
        Args:
            poverty_val (float): Poverty rate (0-60)
            education_val (float): Education level (0-100)
            employment_val (float): Employment rate (0-80)
            
        Returns:
            dict: Results containing eligibility score and scholarship type
        """

        print("poverty_val",poverty_val)
        print("education_val",education_val)
        print("employment_val",employment_val)

        # Evaluate eligibility score
        self.eligibility_simulator.input['poverty'] = poverty_val
        self.eligibility_simulator.input['education'] = education_val
        self.eligibility_simulator.input['employment'] = employment_val
        self.eligibility_simulator.compute()
        
        # Evaluate scholarship type
        self.scholarship_simulator.input['poverty'] = poverty_val
        self.scholarship_simulator.input['education'] = education_val
        self.scholarship_simulator.input['employment'] = employment_val
        self.scholarship_simulator.compute()

        # Get numeric output
        eligibility_score = self.eligibility_simulator.output['eligibility']
        scholarship_score = self.scholarship_simulator.output['scholarship_type']

        print("scholarship_score",scholarship_score)

        # Calculate membership values for each scholarship type
        scholarship_memberships = {}
        for term_name in self.scholarship_type.terms:
            membership_value = fuzz.interp_membership(
                self.scholarship_type.universe, 
                self.scholarship_type[term_name].mf, 
                scholarship_score
            )
            scholarship_memberships[term_name] = float(membership_value)
        
        # Identify best membership function name (vocational, academic, research)
        best_scholarship_type = max(
            self.scholarship_type.terms,
            key=lambda t: fuzz.interp_membership(
                self.scholarship_type.universe, 
                self.scholarship_type[t].mf, 
                scholarship_score
            )
        )

        # Map scholarship type to readable format
        scholarship_type_readable = {
            'vocational': 'Vocational Training Grant',
            'academic': 'Academic Scholarship',
            'research': 'Research Grant'
        }

        print("scholarship_memberships",scholarship_memberships)

        return {
            'eligibility_score': float(eligibility_score) / 100.0,  # Normalize to 0-1
            'scholarship_score': float(scholarship_score) / 100.0,  # Normalize to 0-1
            'scholarship_type': scholarship_type_readable.get(best_scholarship_type, 'Unknown'),
            'scholarship_memberships': {
                scholarship_type_readable.get(term, 'Unknown'): value 
                for term, value in scholarship_memberships.items()
            }
        }
    
    def evaluate_country(self, country_data):
        """
        Evaluate a country using FIS.
        
        Args:
            country_data (dict): Dictionary with country parameters
            
        Returns:
            dict: Dictionary with evaluation results
        """
        # Extract parameters
        poverty_rate = country_data.get('povertyRate', 0)
        education_level = country_data.get('educationLevel', 0)
        employment_rate = country_data.get('employmentRate', 0)
        
        # Scale parameters to the range expected by the FIS
        poverty_scaled = poverty_rate * 60  # 0-1 → 0-60
        education_scaled = education_level * 100  # 0-1 → 0-100
        employment_scaled = employment_rate * 80  # 0-1 → 0-80
        
        # Get prediction
        prediction = self.predict(poverty_scaled, education_scaled, employment_scaled)
        
        return {
            'country': country_data.get('name', 'Unknown'),
            'score': prediction['eligibility_score'],
            'scholarshipTypes': prediction['scholarship_memberships'],
            'recommendedType': prediction['scholarship_type'],
            'details': {
                'povertyRate': str(poverty_rate),
                'educationLevel': str(education_level),
                'employmentRate': str(employment_rate)
            }
        }

# Create singleton instance
fis_predictor = FuzzyInferenceSystem() 

if __name__ == "__main__":
    result = fis_predictor.evaluate_country({
        'povertyRate': 0.5,
        'educationLevel': 0.3,
        'employmentRate': 0.5
    })
    print(result)
