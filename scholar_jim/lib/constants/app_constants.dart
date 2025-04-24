import 'package:flutter/material.dart';

class AppConstants {
  // App name
  static const String appName = "Scholar JIM";
  static const String appVersion = "1.0.0";
  
  // Splash screen duration in seconds
  static const int splashDuration = 3;
  
  // Demo NGOs for the application
  static final List<NgoData> demoNgos = [
    NgoData(
      id: 'un001',
      name: 'United Nations Development Programme',
      acronym: 'UNDP',
      logo: 'assets/icons/undp_logo.png', 
      description: 'Working to eradicate poverty and reduce inequalities through sustainable development.',
      primaryColor: const Color(0xFF009EDB),
    ),
    NgoData(
      id: 'ef002',
      name: 'Education First Foundation',
      acronym: 'EFF',
      logo: 'assets/icons/eff_logo.png',
      description: 'Dedicated to providing education opportunities for underprivileged children worldwide.',
      primaryColor: const Color(0xFF4CAF50),
    ),
    NgoData(
      id: 'gs003',
      name: 'Global Scholarship Initiative',
      acronym: 'GSI',
      logo: 'assets/icons/gsi_logo.png',
      description: 'Connecting talented students with scholarship opportunities across the globe.',
      primaryColor: const Color(0xFFF57C00),
    ),
    NgoData(
      id: 'wv004',
      name: 'World Vision International',
      acronym: 'WVI',
      logo: 'assets/icons/wvi_logo.png',
      description: 'Focusing on child welfare and education in developing countries.',
      primaryColor: const Color(0xFF7B1FA2),
    ),
    NgoData(
      id: 'saf005',
      name: 'Students Across Frontiers',
      acronym: 'SAF',
      logo: 'assets/icons/saf_logo.png',
      description: 'Building bridges through educational and cultural exchange programs.',
      primaryColor: const Color(0xFF0097A7),
    ),
    NgoData(
      id: 'gef006',
      name: 'Global Education Fund',
      acronym: 'GEF',
      logo: 'assets/icons/gef_logo.png',
      description: 'Funding education initiatives and scholarships in regions affected by conflict and poverty.',
      primaryColor: const Color(0xFFD32F2F),
    ),
  ];
  
  // List of available regions/countries for filtering
  static const List<String> availableCountries = [
    'Afghanistan', 'Albania', 'Algeria', 'Angola', 'Argentina', 'Bangladesh',
    'Benin', 'Bolivia', 'Brazil', 'Burkina Faso', 'Burundi', 'Cambodia',
    'Cameroon', 'Central African Republic', 'Chad', 'Colombia', 'Congo',
    'Costa Rica', 'Cuba', 'DR Congo', 'Ecuador', 'Egypt', 'El Salvador',
    'Ethiopia', 'Ghana', 'Guatemala', 'Guinea', 'Haiti', 'Honduras', 'India',
    'Indonesia', 'Iraq', 'Ivory Coast', 'Jordan', 'Kenya', 'Laos', 'Lebanon',
    'Liberia', 'Madagascar', 'Malawi', 'Mali', 'Mexico', 'Morocco', 'Mozambique',
    'Myanmar', 'Nepal', 'Nicaragua', 'Niger', 'Nigeria', 'Pakistan', 'Palestine',
    'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Rwanda', 'Senegal',
    'Sierra Leone', 'Somalia', 'South Africa', 'South Sudan', 'Sri Lanka', 'Sudan',
    'Syria', 'Tanzania', 'Thailand', 'Togo', 'Tunisia', 'Uganda', 'Ukraine',
    'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe'
  ];
  
  // Various scholarship types
  static const List<String> scholarshipTypes = [
    'Undergraduate', 'Graduate', 'PhD', 'Research',
    'Technical Training', 'Vocational', 'Leadership',
    'Women Empowerment', 'Humanitarian', 'Community Development'
  ];
  
  // Criteria factors for the models
  static const List<String> selectionCriteriaFactors = [
    'GDP Per Capita', 'Human Development Index', 'Education Index',
    'Gender Inequality Index', 'Poverty Rate', 'Literacy Rate',
    'Conflict Intensity', 'Natural Disaster Impact', 'Refugee Population'
  ];
}

class NgoData {
  final String id;
  final String name;
  final String acronym;
  final String logo;
  final String description;
  final Color primaryColor;
  
  NgoData({
    required this.id,
    required this.name,
    required this.acronym,
    required this.logo,
    required this.description,
    required this.primaryColor,
  });
} 