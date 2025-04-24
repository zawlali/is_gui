import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:scholar_jim/models/ngo.dart';
import 'package:scholar_jim/models/country_params.dart';
import 'package:scholar_jim/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParametersScreen extends StatefulWidget {
  final NGO ngo;
  final Function(NGO) onSettingsUpdated;

  const ParametersScreen({
    Key? key,
    required this.ngo,
    required this.onSettingsUpdated,
  }) : super(key: key);

  @override
  State<ParametersScreen> createState() => _ParametersScreenState();
}

class _ParametersScreenState extends State<ParametersScreen> {
  late List<CountryParams> _countryParams;
  String? _selectedCountryName;
  final Map<String, String> _countryCodeMap = {};

  // Parameters for the selected country
  double _povertyRate = 0.25;
  double _educationLevel = 0.5;
  double _employmentRate = 0.5;

  @override
  void initState() {
    super.initState();
    _countryParams = List<CountryParams>.from(widget.ngo.countryParams);
    
    // Select the first country by default if available
    if (_countryParams.isNotEmpty) {
      _selectCountry(_countryParams.first.name);
    }
  }

  void _saveSettings() {
    // Save any pending changes to the currently selected country
    _saveCurrentCountryParams();
    
    // Update focus countries from countryParams
    List<String> focusCountries = _countryParams.map((cp) => cp.name).toList();
    
    final updatedNgo = widget.ngo.copyWith(
      focusCountries: focusCountries,
      countryParams: _countryParams,
    );

    widget.onSettingsUpdated(updatedNgo);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Parameters saved successfully'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _addCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(16),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onSelect: (Country country) {
        // Check if the country is already in the list
        if (_countryParams.any((cp) => cp.name == country.name)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${country.name} is already in your list'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
        
        // Save current country before switching
        _saveCurrentCountryParams();
        
        setState(() {
          final newCountry = CountryParams(
            name: country.name,
            povertyRate: 0.25,
            educationLevel: 0.5,
            employmentRate: 0.5,
          );
          _countryParams.add(newCountry);
          // Store country code for flag display
          _countryCodeMap[country.name] = country.countryCode;
          _selectCountry(country.name);
        });
      },
    );
  }

  void _selectCountry(String countryName) {
    // Save current country params before switching
    _saveCurrentCountryParams();
    
    // Find the country by name
    final countryParam = _countryParams.firstWhere(
      (cp) => cp.name == countryName,
      orElse: () => CountryParams(name: ''),
    );
    
    if (countryParam.name.isEmpty) return;
    
    setState(() {
      _selectedCountryName = countryName;
      _povertyRate = countryParam.povertyRate;
      _educationLevel = countryParam.educationLevel;
      _employmentRate = countryParam.employmentRate;
    });
  }

  void _saveCurrentCountryParams() {
    if (_selectedCountryName == null) return;
    
    final index = _countryParams.indexWhere((cp) => cp.name == _selectedCountryName);
    if (index >= 0) {
      _countryParams[index] = _countryParams[index].copyWith(
        povertyRate: _povertyRate,
        educationLevel: _educationLevel,
        employmentRate: _employmentRate,
      );
    }
  }

  void _deleteCountry(String countryName) {
    setState(() {
      _countryParams.removeWhere((item) => item.name == countryName);
      _countryCodeMap.remove(countryName);
      
      // If the deleted country was the selected one, select another one if available
      if (_selectedCountryName == countryName) {
        _selectedCountryName = _countryParams.isNotEmpty ? _countryParams.first.name : null;
        
        if (_selectedCountryName != null) {
          final countryParam = _countryParams.firstWhere((cp) => cp.name == _selectedCountryName);
          _povertyRate = countryParam.povertyRate;
          _educationLevel = countryParam.educationLevel;
          _employmentRate = countryParam.employmentRate;
        }
      }
    });
  }
  
  // Get country code for flag display
  String _getCountryCode(String countryName) {
    // If country code is already stored, use it
    if (_countryCodeMap.containsKey(countryName)) {
      return _countryCodeMap[countryName]!.toLowerCase();
    }
    
    // Otherwise try to determine based on name
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
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar - Country list
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Countries',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (_countryParams.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      color: Colors.amber.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800),
                            const SizedBox(height: 8),
                            const Text(
                              'Add at least 3 countries to use scholarship models',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Show chip with count indicator if fewer than 3 countries
                if (_countryParams.isNotEmpty && _countryParams.length < 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.amber.shade800,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_countryParams.length}/3 countries needed',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _countryParams.length,
                    itemBuilder: (context, index) {
                      final country = _countryParams[index];
                      final isSelected = country.name == _selectedCountryName;
                      final countryCode = _getCountryCode(country.name);
                      
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: countryCode.length == 2
                              ? Image.network(
                                  'https://flagcdn.com/w80/${countryCode}.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        country.name.substring(0, 1),
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    country.name.substring(0, 1),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        title: Text(country.name),
                        subtitle: Text(
                          'PR: ${(country.povertyRate * 100).round()}%, ' 
                          'EL: ${(country.educationLevel * 100).round()}%, ' 
                          'ER: ${(country.employmentRate * 100).round()}%',
                          style: TextStyle(fontSize: 11),
                        ),
                        selected: isSelected,
                        selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
                        selectedColor: AppTheme.primaryColor,
                        onTap: () => _selectCountry(country.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteCountry(country.name),
                          color: Colors.red.shade300,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _addCountry,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Country'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Right side - Parameters for selected country
          Expanded(
            child: _selectedCountryName == null
                ? _buildEmptyState()
                : _buildParametersPane(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Save All Parameters'),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.public, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Country Selected',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a country from the list or add a new one',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParametersPane() {
    final countryCode = _getCountryCode(_selectedCountryName!);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: countryCode.length == 2
                    ? Image.network(
                        'https://flagcdn.com/w160/${countryCode}.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            child: Text(
                              _selectedCountryName!.substring(0, 1),
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      )
                    : CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(
                          _selectedCountryName!.substring(0, 1),
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCountryName!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'Adjust parameters for scholarship allocation',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Socioeconomic Parameters',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 24),
          _buildSliderWithLabel(
            label: 'National Poverty Rate',
            value: _povertyRate,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                _povertyRate = value;
              });
            },
            valueLabel: '${(_povertyRate * 100).round()}%',
            icon: Icons.money_off,
          ),
          const SizedBox(height: 32),
          _buildSliderWithLabel(
            label: 'Average Level of Education',
            value: _educationLevel,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                _educationLevel = value;
              });
            },
            valueLabel: '${(_educationLevel * 100).round()}%',
            icon: Icons.school,
          ),
          const SizedBox(height: 32),
          _buildSliderWithLabel(
            label: 'Employment Rate',
            value: _employmentRate,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                _employmentRate = value;
              });
            },
            valueLabel: '${(_employmentRate * 100).round()}%',
            icon: Icons.work,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderWithLabel({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String valueLabel,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                valueLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
            inactiveColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Low', style: TextStyle(color: Colors.grey.shade600)),
            Text('High', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _getParameterDescription(label, value),
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
      ],
    );
  }

  String _getParameterDescription(String paramName, double value) {
    if (paramName == 'National Poverty Rate') {
      if (value < 0.3) {
        return 'Low poverty rate indicates a good standard of living in the country.';
      } else if (value < 0.6) {
        return 'Moderate poverty rate suggests some economic challenges in the country.';
      } else {
        return 'High poverty rate indicates significant economic challenges and need for support.';
      }
    } else if (paramName == 'Average Level of Education') {
      if (value < 0.3) {
        return 'Low education level suggests a need for basic educational support.';
      } else if (value < 0.6) {
        return 'Moderate education level indicates some educational infrastructure is in place.';
      } else {
        return 'High education level suggests strong educational foundation in the country.';
      }
    } else { // Employment Rate
      if (value < 0.3) {
        return 'Low employment rate indicates significant economic challenges in the country.';
      } else if (value < 0.6) {
        return 'Moderate employment rate suggests a developing job market.';
      } else {
        return 'High employment rate indicates a strong job market and economic stability.';
      }
    }
  }
} 