import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scholar_jim/models/ngo.dart';
import 'package:scholar_jim/models/country_params.dart';
import 'package:scholar_jim/models/scholarship_result.dart';

class ScholarshipService {
  // Base URL for the API server
  static const String baseUrl = 'http://localhost:5000';
  
  // Singleton pattern
  static final ScholarshipService _instance = ScholarshipService._internal();
  factory ScholarshipService() => _instance;
  ScholarshipService._internal();

  /// Evaluates countries using either the FIS or ANN model
  Future<ScholarshipResultSet> evaluateCountries(
    String ngoId,
    List<CountryParams> countries, {
    String modelType = 'FIS',
  }) async {
    try {
      // Convert CountryParams to the format expected by the API
      final countryDataList = countries.map((country) => {
        'name': country.name,
        'povertyRate': country.povertyRate,
        'educationLevel': country.educationLevel,
        'employmentRate': country.employmentRate,
      }).toList();

      // Prepare request body
      final requestBody = jsonEncode({
        'ngoId': ngoId,
        'modelType': modelType,
        'countries': countryDataList,
      });

      // Make the API call
      final response = await http.post(
        Uri.parse('$baseUrl/evaluate/countries'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      // Check for successful response
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        
        // Parse results into ScholarshipResult objects
        final resultsJson = decodedResponse['results'] as List<dynamic>;
        final results = resultsJson.map((resultJson) {
          // Parse scholarship types
          final scholarshipTypesJson = resultJson['scholarshipTypes'] as Map<String, dynamic>;
          final scholarshipTypes = Map<String, double>.from(
            scholarshipTypesJson.map((key, value) => MapEntry(key, value.toDouble()))
          );
          
          return ScholarshipResult(
            country: resultJson['country'],
            score: resultJson['score'].toDouble(),
            modelType: modelType,
            details: Map<String, dynamic>.from(resultJson['details']),
            scholarshipTypes: scholarshipTypes,
            recommendedType: resultJson['recommendedType'],
          );
        }).toList();
        
        // Create and return ScholarshipResultSet
        return ScholarshipResultSet(
          ngoId: ngoId,
          modelType: modelType,
          generatedAt: DateTime.parse(decodedResponse['generatedAt']),
          results: results,
        );
      } else {
        // Handle error responses
        throw Exception('Failed to evaluate countries. Status: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (e) {
      // Re-throw with more context
      throw Exception('API Error: $e');
    }
  }

  /// Evaluate countries using the FIS model
  Future<ScholarshipResultSet> evaluateCountriesFIS(
    String ngoId,
    List<CountryParams> countries,
  ) {
    return evaluateCountries(ngoId, countries, modelType: 'FIS');
  }

  /// Evaluate countries using the ANN model
  Future<ScholarshipResultSet> evaluateCountriesANN(
    String ngoId,
    List<CountryParams> countries,
  ) {
    return evaluateCountries(ngoId, countries, modelType: 'ANN');
  }

  /// Simple health check for the API server
  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
} 