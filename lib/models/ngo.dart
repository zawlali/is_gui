import 'country_params.dart';

class NGO {
  final String id;
  final String name;
  final String logoPath;
  final String description;
  final List<String> focusCountries;
  final Map<String, dynamic> settings;
  final List<CountryParams> countryParams;

  NGO({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.description,
    required this.focusCountries,
    required this.settings,
    this.countryParams = const [],
  });

  NGO copyWith({
    String? id,
    String? name,
    String? logoPath,
    String? description,
    List<String>? focusCountries,
    Map<String, dynamic>? settings,
    List<CountryParams>? countryParams,
  }) {
    return NGO(
      id: id ?? this.id,
      name: name ?? this.name,
      logoPath: logoPath ?? this.logoPath,
      description: description ?? this.description,
      focusCountries: focusCountries ?? this.focusCountries,
      settings: settings ?? this.settings,
      countryParams: countryParams ?? this.countryParams,
    );
  }
} 