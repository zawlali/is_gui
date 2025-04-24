import 'package:scholar_jim/models/ngo.dart';
import 'package:scholar_jim/models/scholarship_result.dart';
import 'package:scholar_jim/models/country_params.dart';
import 'dart:math';

class SampleData {
  // Helper function to create a list of sample countries for each NGO
  static List<CountryParams> _getSampleCountriesForNGO(String ngoId) {
    switch (ngoId) {
      case '2': // Bright Future Initiative - Africa focused
        return [
          CountryParams(
            name: 'Kenya',
            povertyRate: 0.35,
            educationLevel: 0.55,
            employmentRate: 0.60,
          ),
          CountryParams(
            name: 'Nigeria',
            povertyRate: 0.40,
            educationLevel: 0.58,
            employmentRate: 0.62,
          ),
          CountryParams(
            name: 'South Africa',
            povertyRate: 0.25,
            educationLevel: 0.70,
            employmentRate: 0.65,
          ),
          CountryParams(
            name: 'Ghana',
            povertyRate: 0.33,
            educationLevel: 0.60,
            employmentRate: 0.58,
          ),
          CountryParams(
            name: 'Ethiopia',
            povertyRate: 0.45,
            educationLevel: 0.48,
            employmentRate: 0.52,
          ),
        ];
        
      case '3': // Women in STEM Foundation - Asia focused
        return [
          CountryParams(
            name: 'India',
            povertyRate: 0.28,
            educationLevel: 0.65,
            employmentRate: 0.60,
          ),
          CountryParams(
            name: 'China',
            povertyRate: 0.18,
            educationLevel: 0.75,
            employmentRate: 0.78,
          ),
          CountryParams(
            name: 'Sri Lanka',
            povertyRate: 0.22,
            educationLevel: 0.68,
            employmentRate: 0.65,
          ),
          CountryParams(
            name: 'Malaysia',
            povertyRate: 0.15,
            educationLevel: 0.72,
            employmentRate: 0.70,
          ),
          CountryParams(
            name: 'Indonesia',
            povertyRate: 0.30,
            educationLevel: 0.62,
            employmentRate: 0.63,
          ),
        ];
        
      case '4': // Pacific Rim Opportunities
        return [
          CountryParams(
            name: 'Japan',
            povertyRate: 0.12,
            educationLevel: 0.85,
            employmentRate: 0.80,
          ),
          CountryParams(
            name: 'South Korea',
            povertyRate: 0.14,
            educationLevel: 0.82,
            employmentRate: 0.78,
          ),
          CountryParams(
            name: 'Philippines',
            povertyRate: 0.32,
            educationLevel: 0.64,
            employmentRate: 0.62,
          ),
          CountryParams(
            name: 'Vietnam',
            povertyRate: 0.26,
            educationLevel: 0.70,
            employmentRate: 0.68,
          ),
          CountryParams(
            name: 'Thailand',
            povertyRate: 0.20,
            educationLevel: 0.72,
            employmentRate: 0.75,
          ),
        ];
        
      case '5': // Latin American Scholars
        return [
          CountryParams(
            name: 'Brazil',
            povertyRate: 0.30,
            educationLevel: 0.68,
            employmentRate: 0.65,
          ),
          CountryParams(
            name: 'Mexico',
            povertyRate: 0.28,
            educationLevel: 0.70,
            employmentRate: 0.68,
          ),
          CountryParams(
            name: 'Colombia',
            povertyRate: 0.32,
            educationLevel: 0.65,
            employmentRate: 0.63,
          ),
          CountryParams(
            name: 'Argentina',
            povertyRate: 0.25,
            educationLevel: 0.72,
            employmentRate: 0.68,
          ),
          CountryParams(
            name: 'Chile',
            povertyRate: 0.18,
            educationLevel: 0.78,
            employmentRate: 0.72,
          ),
        ];
        
      case '6': // Universal Scholarship Trust - Global focus
        return [
          CountryParams(
            name: 'United States',
            povertyRate: 0.15,
            educationLevel: 0.82,
            employmentRate: 0.75,
          ),
          CountryParams(
            name: 'Germany',
            povertyRate: 0.12,
            educationLevel: 0.85,
            employmentRate: 0.80,
          ),
          CountryParams(
            name: 'Egypt',
            povertyRate: 0.35,
            educationLevel: 0.62,
            employmentRate: 0.58,
          ),
          CountryParams(
            name: 'Australia',
            povertyRate: 0.14,
            educationLevel: 0.85,
            employmentRate: 0.78,
          ),
          CountryParams(
            name: 'Canada',
            povertyRate: 0.13,
            educationLevel: 0.88,
            employmentRate: 0.76,
          ),
        ];
      
      default:
        return [];
    }
  }

  static List<NGO> getNGOs() {
    final ngos = [
      NGO(
        id: '1',
        name: 'Global Education Fund',
        logoPath: 'assets/images/gef_logo.png',
        description: 'Providing education opportunities to underprivileged communities worldwide.',
        focusCountries: [],
        settings: {
          'minScholarshipAmount': 5000,
          'maxScholarshipAmount': 15000,
          'priorityFields': ['STEM', 'Healthcare', 'Education'],
          'countryFilters': ['Africa', 'Asia'],
        },
        countryParams: [],
      ),
      NGO(
        id: '2',
        name: 'Bright Future Initiative',
        logoPath: 'assets/images/bfi_logo.png',
        description: 'Empowering youth through educational scholarships and leadership development.',
        focusCountries: [],
        settings: {
          'minScholarshipAmount': 3000,
          'maxScholarshipAmount': 12000,
          'priorityFields': ['Business', 'Technology', 'Leadership'],
          'countryFilters': ['Africa'],
        },
        countryParams: [],
      ),
      NGO(
        id: '3',
        name: 'Women in STEM Foundation',
        logoPath: 'assets/images/wisf_logo.png',
        description: 'Supporting women pursuing careers in science, technology, engineering, and mathematics.',
        focusCountries: [],
        settings: {
          'minScholarshipAmount': 4000,
          'maxScholarshipAmount': 20000,
          'priorityFields': ['Engineering', 'Computer Science', 'Mathematics'],
          'countryFilters': ['Asia'],
        },
        countryParams: [],
      ),
      NGO(
        id: '4',
        name: 'Pacific Rim Opportunities',
        logoPath: 'assets/images/pro_logo.png',
        description: 'Creating educational opportunities for students in Pacific Rim countries.',
        focusCountries: [],
        settings: {
          'minScholarshipAmount': 3500,
          'maxScholarshipAmount': 10000,
          'priorityFields': ['Marine Sciences', 'Environmental Studies', 'International Relations'],
          'countryFilters': ['Southeast Asia', 'East Asia'],
        },
        countryParams: [],
      ),
      NGO(
        id: '5',
        name: 'Latin American Scholars',
        logoPath: 'assets/images/las_logo.png',
        description: 'Advancing education throughout Latin America with merit-based scholarships.',
        focusCountries: [],
        settings: {
          'minScholarshipAmount': 4000,
          'maxScholarshipAmount': 12000,
          'priorityFields': ['Public Health', 'Environmental Science', 'Urban Planning'],
          'countryFilters': ['South America', 'Central America'],
        },
        countryParams: [],
      ),
      NGO(
        id: '6',
        name: 'Universal Scholarship Trust',
        logoPath: 'assets/images/ust_logo.png',
        description: 'Providing global access to education through need-based scholarships.',
        focusCountries: [],
        settings: {
          'minScholarshipAmount': 2000,
          'maxScholarshipAmount': 25000,
          'priorityFields': ['All Fields'],
          'countryFilters': ['Global'],
        },
        countryParams: [],
      ),
    ];
    
    // Add country data and focus countries to each NGO except the first one
    for (int i = 1; i < ngos.length; i++) {
      final ngo = ngos[i];
      final countryParams = _getSampleCountriesForNGO(ngo.id);
      
      // Update the NGO with country parameters and focus countries
      ngos[i] = ngo.copyWith(
        countryParams: countryParams,
        focusCountries: countryParams.map((cp) => cp.name).toList(),
      );
    }
    
    return ngos;
  }

  static ScholarshipResultSet generateSampleResults({required String ngoId, required String modelType, required List<CountryParams> countryParams}) {
    final Random random = Random();
    
    final List<ScholarshipResult> results = countryParams.map((countryParam) {
      // Calculate score based on country parameters
      final score = (0.7 - countryParam.povertyRate * 0.5 + countryParam.educationLevel * 0.3 + countryParam.employmentRate * 0.2).clamp(0.0, 1.0);
      
      // Generate random scholarship type percentages
      final vocationalTraining = 0.2 + random.nextDouble() * 0.3;
      final academicScholarship = 0.3 + random.nextDouble() * 0.4;
      final researchGrant = 1.0 - vocationalTraining - academicScholarship;
      
      final scholarshipTypes = {
        'Vocational Training Grant': vocationalTraining,
        'Academic Scholarship': academicScholarship,
        'Research Grant': researchGrant,
      };
      
      // Determine recommended type
      String recommendedType = 'Academic Scholarship';
      double maxValue = academicScholarship;
      
      if (vocationalTraining > maxValue) {
        maxValue = vocationalTraining;
        recommendedType = 'Vocational Training Grant';
      }
      
      if (researchGrant > maxValue) {
        recommendedType = 'Research Grant';
      }
      
      return ScholarshipResult(
        country: countryParam.name,
        score: score,
        modelType: modelType,
        details: {
          'povertyRate': countryParam.povertyRate.toStringAsFixed(2),
          'educationLevel': countryParam.educationLevel.toStringAsFixed(2),
          'employmentRate': countryParam.employmentRate.toStringAsFixed(2),
        },
        scholarshipTypes: scholarshipTypes,
        recommendedType: recommendedType,
      );
    }).toList();
    
    // Sort by score in descending order
    results.sort((a, b) => b.score.compareTo(a.score));
    
    return ScholarshipResultSet(
      ngoId: ngoId,
      modelType: modelType,
      generatedAt: DateTime.now(),
      results: results,
    );
  }
} 