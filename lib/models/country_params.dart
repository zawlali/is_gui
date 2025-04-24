class CountryParams {
  final String name;
  final double povertyRate;
  final double educationLevel;
  final double employmentRate;

  CountryParams({
    required this.name,
    required this.povertyRate,
    required this.educationLevel,
    required this.employmentRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'povertyRate': povertyRate,
      'educationLevel': educationLevel,
      'employmentRate': employmentRate,
    };
  }

  factory CountryParams.fromJson(Map<String, dynamic> json) {
    return CountryParams(
      name: json['name'] as String,
      povertyRate: (json['povertyRate'] as num).toDouble(),
      educationLevel: (json['educationLevel'] as num).toDouble(),
      employmentRate: (json['employmentRate'] as num).toDouble(),
    );
  }

  CountryParams copyWith({
    String? name,
    double? povertyRate,
    double? educationLevel,
    double? employmentRate,
  }) {
    return CountryParams(
      name: name ?? this.name,
      povertyRate: povertyRate ?? this.povertyRate,
      educationLevel: educationLevel ?? this.educationLevel,
      employmentRate: employmentRate ?? this.employmentRate,
    );
  }
} 