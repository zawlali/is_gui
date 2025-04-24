import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:scholar_jim/models/ngo.dart';
import 'package:scholar_jim/models/scholarship_result.dart';
import 'package:scholar_jim/theme/app_theme.dart';
import 'package:scholar_jim/utils/sample_data.dart';
import 'package:country_flags/country_flags.dart';
import 'package:scholar_jim/services/scholarship_service.dart';

class ResultsScreen extends StatefulWidget {
  final NGO ngo;
  final String modelType;

  const ResultsScreen({Key? key, required this.ngo, required this.modelType})
    : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late ScholarshipResultSet _resultSet;
  String? _errorMessage;
  final _scholarshipService = ScholarshipService();
  
  // For tab controller to switch between different chart views
  late TabController _tabController;
  int _selectedCountryIndex = 0; // For scholarship type comparison

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
      
  Future<void> _loadResults() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.ngo.countryParams.isEmpty) {
        throw Exception("No countries configured for this NGO");
      }
      
      if (widget.modelType == 'Fuzzy') {
        // Use the Fuzzy Inference System
        final resultSet = await _scholarshipService.evaluateCountriesFIS(
          widget.ngo.id,
          widget.ngo.countryParams,
        );
        
        setState(() {
          _resultSet = resultSet;
          _isLoading = false;
          if (_resultSet.results.isNotEmpty) {
            _selectedCountryIndex = 0;
          }
        });
      } else {
        // Use the ANN model
        final resultSet = await _scholarshipService.evaluateCountriesANN(
          widget.ngo.id,
          widget.ngo.countryParams,
        );
        
        setState(() {
          _resultSet = resultSet;
          _isLoading = false;
          if (_resultSet.results.isNotEmpty) {
            _selectedCountryIndex = 0;
          }
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Helper function to get country code for flag display
  String _getCountryCode(String countryName) {
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
      'South Africa': 'za',
      'Nigeria': 'ng',
      'Kenya': 'ke',
      'Egypt': 'eg',
      'Argentina': 'ar',
      'Colombia': 'co',
      'Peru': 'pe',
      'Chile': 'cl',
      'Sweden': 'se',
      'Norway': 'no',
      'Denmark': 'dk',
      'Finland': 'fi',
      'Netherlands': 'nl',
      'Belgium': 'be',
      'Switzerland': 'ch',
      'Austria': 'at',
      'Portugal': 'pt',
      'Greece': 'gr',
      'Turkey': 'tr',
      'Indonesia': 'id',
      'Malaysia': 'my',
      'Thailand': 'th',
      'Vietnam': 'vn',
      'Philippines': 'ph',
      'Singapore': 'sg',
      'New Zealand': 'nz',
      'Pakistan': 'pk',
      'Bangladesh': 'bd',
      'Sri Lanka': 'lk',
    };

    if (commonMappings.containsKey(countryName)) {
      return commonMappings[countryName]!;
    }

    // Try to determine based on name if not in common mappings
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

    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.modelType} Model Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadResults();
            },
          ),
        ],
      ),
      body: _isLoading 
          ? _buildLoadingView() 
          : _errorMessage != null 
              ? _buildErrorView() 
              : _buildResultsView(),
      floatingActionButton:
          !_isLoading && _errorMessage == null
              ? FloatingActionButton.extended(
                onPressed: () {
                  // In a real app, this would export the results to PDF or share them
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Export functionality would be implemented here',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Results'),
              )
              : null,
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWave(color: AppTheme.primaryColor, size: 50.0),
          const SizedBox(height: 24),
          Text(
            'Running ${widget.modelType} Model',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            widget.modelType == 'Fuzzy'
                ? 'Evaluating countries with Fuzzy Inference System...'
                : 'Analyzing data for optimal scholarship allocation...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $_errorMessage',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadResults,
            child: const Text('Retry'),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Make sure the model server is running at ${ScholarshipService.baseUrl}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    // Get top 5 countries for chart
    final topCountries = _resultSet.results.take(5).toList();
    final selectedCountry = _selectedCountryIndex < _resultSet.results.length 
        ? _resultSet.results[_selectedCountryIndex] 
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
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
                        widget.modelType == 'ANN'
                            ? Icons.psychology
                            : Icons.layers,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.modelType == 'ANN'
                              ? 'Artificial Neural Network Results'
                              : 'Fuzzy Logic System Results',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generated for ${widget.ngo.name}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Date: ${_resultSet.generatedAt.toString().substring(0, 16)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Tab bar to switch between chart views
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Eligibility Scores'),
                      Tab(text: 'Scholarship Type Comparison'),
                    ],
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  
                  // Tab bar view for different charts
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Eligibility scores chart
                        _buildBarChart(topCountries),
                        
                        // Scholarship type comparison chart
                        Column(
                          children: [
                            DropdownButton<int>(
                              value: _selectedCountryIndex,
                              hint: const Text('Select Country'),
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedCountryIndex = newValue;
                                  });
                                }
                              },
                              items: _resultSet.results.asMap().entries.map((entry) {
                                return DropdownMenuItem<int>(
                                  value: entry.key,
                                  child: Text(entry.value.country),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            if (selectedCountry != null)
                              Expanded(
                                child: _buildScholarshipTypeChart(selectedCountry),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          Text(
            'Country Rankings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _resultSet.results.asMap().entries.map((entry) {
              final index = entry.key;
              final result = entry.value;
              // Calculate fixed width based on available space
              // We want 3 cards per row with 16 pixel spacing between them
              final screenWidth = MediaQuery.of(context).size.width;
              final cardWidth = (screenWidth - 32 - 32) / 3; // screen width - padding - spacing
              
              return SizedBox(
                width: cardWidth,
                child: _buildResultCard(result, index),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<ScholarshipResult> topCountries) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= topCountries.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    topCountries[value.toInt()].country,
                    style: const TextStyle(
                      color: AppTheme.lightTextColor,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(topCountries.length, (index) {
          final result = topCountries[index];
          // Use different colors for the first three bars
          Color barColor;
          if (index == 0) {
            barColor = Colors.amber;
          } else if (index == 1) {
            barColor = Colors.lightBlueAccent.shade100;
          } else if (index == 2) {
            barColor = Colors.greenAccent.shade200;
          } else {
            barColor = Colors.grey.shade300;
          }

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: result.score,
                color: barColor,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                // Add percentage label on top of the bar
                rodStackItems: [
                  BarChartRodStackItem(
                    0,
                    result.score,
                    Colors.transparent,
                    BorderSide.none,
                  ),
                ],
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ],
            // Show percentage above each bar
            showingTooltipIndicators: [0],
          );
        }),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final result = topCountries[group.x.toInt()];
              return BarTooltipItem(
                '${(result.score * 100).toStringAsFixed(1)}%',
                TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(ScholarshipResult result, int index) {
    final countryCode = _getCountryCode(result.country);
    final isTopThree = index < 3;
    
    // Changed to use primary color for all cards with different opacity
    final cardColor = isTopThree
        ? AppTheme.primaryColor
        : AppTheme.primaryColor.withOpacity(0.85);
    
    // Format parameter values
    final povertyRate = double.parse(result.details['povertyRate'] ?? '0.0');
    final educationLevel = double.parse(result.details['educationLevel'] ?? '0.0');
    final employmentRate = double.parse(result.details['employmentRate'] ?? '0.0');
    
    return Card(
      elevation: isTopThree ? 3 : 1,
      color: cardColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isTopThree
            ? BorderSide(color: Colors.white.withOpacity(0.3), width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rank badge and country flag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rank badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTopThree ? Colors.amber : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: TextStyle(
                      color: isTopThree ? Colors.black87 : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                // Country flag
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: countryCode.length == 2
                      ? Image.network(
                          'https://flagcdn.com/w80/${countryCode}.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                result.country.substring(0, 1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            result.country.substring(0, 1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Country name and eligibility score in compact layout
            Text(
              result.country,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(result.score * 100).toStringAsFixed(1)}% eligible',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Country parameters - more compact
            Row(
              children: [
                Icon(Icons.trending_down, size: 14, color: Colors.redAccent.shade200),
                const SizedBox(width: 4),
                Text(
                  'Poverty: ${(povertyRate * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Icon(Icons.school, size: 14, color: Colors.lightBlueAccent.shade100),
                const SizedBox(width: 4),
                Text(
                  'Edu: ${(educationLevel * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Icon(Icons.work, size: 14, color: Colors.lightGreenAccent.shade100),
                const SizedBox(width: 4),
                Text(
                  'Employment: ${(employmentRate * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Recommendation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      result.recommendedType,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // Scholarship types in compact format
            const SizedBox(height: 10),
            ...result.scholarshipTypes.entries.map((entry) {
              final isRecommended = entry.key == result.recommendedType;
              final shortName = _shortenScholarshipType(entry.key);
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    if (isRecommended)
                      Icon(Icons.star, size: 11, color: Colors.amber)
                    else
                      const SizedBox(width: 11),
                    SizedBox(
                      width: 65,
                      child: Text(
                        shortName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isRecommended ? FontWeight.bold : FontWeight.normal,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: entry.value,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        color: isRecommended ? Colors.amber : Colors.white.withOpacity(0.7),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(entry.value * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _shortenScholarshipType(String type) {
    switch (type) {
      case 'Vocational Training Grant':
        return 'Vocational';
      case 'Academic Scholarship':
        return 'Academic';
      case 'Research Grant':
        return 'Research';
      default:
        return type;
    }
  }

  String _formatDetailName(String key) {
    // Convert camelCase to Title Case with spaces
    final result = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );

    return result.substring(0, 1).toUpperCase() + result.substring(1);
  }

  // Add a new widget for scholarship type comparison chart
  Widget _buildScholarshipTypeChart(ScholarshipResult country) {
    // Prepare data for the chart
    final scholarshipTypes = [
      'Vocational Training Grant',
      'Academic Scholarship',
      'Research Grant',
    ];
    
    final scholarshipScores = scholarshipTypes.map((type) {
      return country.scholarshipTypes[type] ?? 0.0;
    }).toList();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1.0,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= scholarshipTypes.length) {
                  return const SizedBox.shrink();
                }
                
                // Abbreviate the scholarship type names
                String label;
                switch (value.toInt()) {
                  case 0:
                    label = 'Vocational';
                    break;
                  case 1:
                    label = 'Academic';
                    break;
                  case 2:
                    label = 'Research';
                    break;
                  default:
                    label = '';
                }
                
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.lightTextColor,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(scholarshipTypes.length, (index) {
          // Use different colors for each scholarship type
          Color barColor;
          if (index == 0) { // Vocational
            barColor = Colors.deepPurpleAccent;
          } else if (index == 1) { // Academic
            barColor = Colors.blueAccent;
          } else { // Research
            barColor = Colors.teal;
          }
          
          // Highlight the recommended type
          bool isRecommended = scholarshipTypes[index] == country.recommendedType;
          
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: scholarshipScores[index],
                color: isRecommended 
                    ? Colors.amber // Use amber for recommended type
                    : barColor,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final score = scholarshipScores[group.x.toInt()];
              return BarTooltipItem(
                '${(score * 100).toStringAsFixed(1)}%',
                TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
