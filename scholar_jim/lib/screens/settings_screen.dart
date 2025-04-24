import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:scholar_jim/models/ngo.dart';
import 'package:scholar_jim/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final NGO ngo;
  final Function(NGO) onSettingsUpdated;

  const SettingsScreen({
    Key? key,
    required this.ngo,
    required this.onSettingsUpdated,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;
  late List<String> _selectedCountries;
  late List<String> _selectedFields;
  late List<String> _selectedRegions;

  final List<String> _availableFields = [
    'STEM',
    'Healthcare',
    'Education',
    'Business',
    'Technology',
    'Leadership',
    'Engineering',
    'Computer Science',
    'Mathematics',
    'Marine Sciences',
    'Environmental Studies',
    'International Relations',
    'Public Health',
    'Environmental Science',
    'Urban Planning',
    'Arts & Humanities',
    'Social Sciences',
    'Law',
  ];

  final List<String> _availableRegions = [
    'Africa',
    'Asia',
    'Southeast Asia',
    'East Asia',
    'South America',
    'Central America',
    'North America',
    'Europe',
    'Middle East',
    'Oceania',
    'Global',
  ];

  @override
  void initState() {
    super.initState();
    _minAmountController = TextEditingController(
      text: widget.ngo.settings['minScholarshipAmount']?.toString() ?? '5000',
    );
    _maxAmountController = TextEditingController(
      text: widget.ngo.settings['maxScholarshipAmount']?.toString() ?? '15000',
    );
    _selectedCountries = List<String>.from(widget.ngo.focusCountries);
    _selectedFields = List<String>.from(widget.ngo.settings['priorityFields'] ?? ['STEM', 'Education']);
    _selectedRegions = List<String>.from(widget.ngo.settings['countryFilters'] ?? ['Global']);
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final updatedNgo = widget.ngo.copyWith(
      focusCountries: _selectedCountries,
      settings: {
        ...widget.ngo.settings,
        'minScholarshipAmount': int.tryParse(_minAmountController.text) ?? 0,
        'maxScholarshipAmount': int.tryParse(_maxAmountController.text) ?? 0,
        'priorityFields': _selectedFields,
        'countryFilters': _selectedRegions,
      },
    );

    widget.onSettingsUpdated(updatedNgo);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
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
        setState(() {
          if (!_selectedCountries.contains(country.name)) {
            _selectedCountries.add(country.name);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NGO Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Scholarship Amount',
            icon: Icons.attach_money,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Minimum Amount',
                        prefixIcon: Icon(Icons.remove),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _maxAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Maximum Amount',
                        prefixIcon: Icon(Icons.add),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Focus Countries',
            icon: Icons.public,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._selectedCountries.map((country) {
                    return Chip(
                      label: Text(country),
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedCountries.remove(country);
                        });
                      },
                    );
                  }),
                  ActionChip(
                    avatar: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                    label: const Text('Add Country'),
                    onPressed: _addCountry,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Priority Fields',
            icon: Icons.school,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableFields.map((field) {
                  final isSelected = _selectedFields.contains(field);
                  return FilterChip(
                    label: Text(field),
                    selected: isSelected,
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.secondaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedFields.add(field);
                        } else {
                          _selectedFields.remove(field);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Region Filters',
            icon: Icons.language,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableRegions.map((region) {
                  final isSelected = _selectedRegions.contains(region);
                  return FilterChip(
                    label: Text(region),
                    selected: isSelected,
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.secondaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedRegions.add(region);
                        } else {
                          _selectedRegions.remove(region);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Save Settings'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
} 
