class ScholarshipResult {
  final String country;
  final double score;
  final String modelType; // "ANN" or "Fuzzy"
  final Map<String, dynamic> details;
  final Map<String, double> scholarshipTypes;
  final String recommendedType;

  ScholarshipResult({
    required this.country,
    required this.score,
    required this.modelType,
    required this.details,
    this.scholarshipTypes = const {
      'Vocational Training Grant': 0.0,
      'Academic Scholarship': 0.0,
      'Research Grant': 0.0,
    },
    this.recommendedType = 'Academic Scholarship',
  });
}

class ScholarshipResultSet {
  final String ngoId;
  final String modelType;
  final DateTime generatedAt;
  final List<ScholarshipResult> results;

  ScholarshipResultSet({
    required this.ngoId,
    required this.modelType,
    required this.generatedAt,
    required this.results,
  });
} 