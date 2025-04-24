import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scholar_jim/models/ngo.dart';
import 'package:scholar_jim/screens/results_screen.dart';
import 'package:scholar_jim/screens/parameters_screen.dart';
import 'package:scholar_jim/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  final NGO ngo;
  final int initialTabIndex;

  const DashboardScreen({
    Key? key, 
    required this.ngo, 
    this.initialTabIndex = 1, // Default to parameters tab
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;
  late NGO _currentNgo;

  @override
  void initState() {
    super.initState();
    _currentNgo = widget.ngo;
    _selectedIndex = widget.initialTabIndex;
  }

  void _updateNGO(NGO updatedNgo) {
    setState(() {
      _currentNgo = updatedNgo;
    });
  }

  void _onItemTapped(int index) {
    // Check if user has added at least 3 countries before allowing to go to home tab
    if (index == 0 && _currentNgo.countryParams.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 3 countries in Parameters before proceeding'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToResults(String modelType) {
    if (_currentNgo.countryParams.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 3 countries in Parameters before running models'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          ngo: _currentNgo,
          modelType: modelType,
        ),
      ),
    );
  }
  
  // Helper function to get country code for flag display
  String _getCountryCode(String countryName) {
    // Try to determine based on name
    final parts = countryName.split(' ');
    String code = '';
    if (parts.length > 1) {
      // Take first letter of each word
      code = parts.map((p) => p[0]).join('').toLowerCase();
    } else if (countryName.length >= 2) {
      // Take first two letters
      code = countryName.substring(0, 2).toLowerCase();
    } else {
      // Fallback
      code = 'un';
    }
    
    // Common country code mappings for better accuracy
    final commonMappings = {
      'United States': 'us',
      'United Kingdom': 'gb',
      'Great Britain': 'gb',
      'Germany': 'de',
      'France': 'fr',
      'Italy': 'it',
      'Spain': 'es',
      'Canada': 'ca',
      'China': 'cn',
      'Japan': 'jp',
      'Australia': 'au',
      'India': 'in',
      'Brazil': 'br',
      'Mexico': 'mx',
      'Russia': 'ru',
    };
    
    return commonMappings[countryName] ?? code;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      _buildHomeTab(),
      ParametersScreen(
        ngo: _currentNgo,
        onSettingsUpdated: _updateNGO,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentNgo.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildAboutDialog(),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Parameters',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.business,
                    size: 36,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentNgo.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentNgo.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Focus Countries:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  _currentNgo.focusCountries.isEmpty
                      ? Text(
                          'No countries configured. Please add countries in Parameters tab.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _currentNgo.focusCountries
                              .map((country) => Chip(
                                    avatar: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://flagcdn.com/w40/${_getCountryCode(country)}.png',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 24,
                                            height: 24,
                                            color: AppTheme.primaryColor.withOpacity(0.2),
                                            child: Center(
                                              child: Text(
                                                country.substring(0, 1),
                                                style: TextStyle(
                                                  color: AppTheme.primaryColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    label: Text(country),
                                    backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                                    labelStyle: GoogleFonts.workSans(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ))
                              .toList(),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select Scholarship Model',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildModelCard(
            title: 'Artificial Neural Network',
            description: 'Use ANN to analyze historical data and predict optimal scholarship allocation.',
            icon: Icons.psychology,
            onTap: () => _navigateToResults('ANN'),
          ),
          const SizedBox(height: 16),
          _buildModelCard(
            title: 'Fuzzy Logic System',
            description: 'Use fuzzy logic to make scholarship decisions based on multiple variables.',
            icon: Icons.layers,
            onTap: () => _navigateToResults('Fuzzy'),
          ),
          const SizedBox(height: 24),
          // Only show the warning card if there are fewer than 3 countries
          if (_currentNgo.countryParams.length < 3)
            Card(
              color: Colors.amber.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber.shade800,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Add at least 3 countries in the Parameters tab to enable scholarship model features.',
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModelCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.lightTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutDialog() {
    return AlertDialog(
      title: const Text('About Scholar Jim'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scholar Jim is an advanced application designed for NGOs to efficiently allocate scholarships using artificial intelligence and fuzzy logic systems.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Artificial Neural Network Analysis'),
            _buildFeatureItem('Fuzzy Logic Decision System'),
            _buildFeatureItem('Country-specific targeting'),
            _buildFeatureItem('Customizable scholarship criteria'),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
} 