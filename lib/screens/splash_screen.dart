import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:scholar_jim/models/ngo.dart';
import 'package:scholar_jim/screens/dashboard_screen.dart';
import 'package:scholar_jim/theme/app_theme.dart';
import 'package:scholar_jim/utils/sample_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final List<NGO> _ngos = SampleData.getNGOs();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNGOSelected(NGO ngo) {
    // Check if the NGO has at least 3 countries
    final bool hasEnoughCountries = ngo.countryParams.length >= 3;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          ngo: ngo,
          // Start on home tab if has 3+ countries, otherwise parameters tab
          initialTabIndex: hasEnoughCountries ? 0 : 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withOpacity(0.8),
              AppTheme.secondaryColor.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.school,
                                size: 80,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Scholar Jim',
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Intelligent Scholarship Allocation',
                                style: GoogleFonts.workSans(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Text(
                                'Select your organization:',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: _ngos.length,
                                itemBuilder: (context, index) {
                                  final ngo = _ngos[index];
                                  return _buildNGOCard(ngo);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  color: Colors.black.withOpacity(0.3),
                  child: Text(
                    '© 2023 Scholar Jim - Scholarship Selection AI',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.workSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              ],
            ),
        ),
      ),
    );
  }

  Widget _buildNGOCard(NGO ngo) {
    // Map of logo asset paths based on NGO ID
    final logoMap = {
      '1': 'icons/1.png',
      '2': 'icons/2.png',
      '3': 'icons/3.png',
      '4': 'icons/4.png',
      '5': 'icons/5.png',
      '6': 'icons/6.png',
    };

    return GestureDetector(
      onTap: () => _onNGOSelected(ngo),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  logoMap[ngo.id] ?? 'icons/1.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.business,
                      size: 36,
                      color: AppTheme.primaryColor,
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ngo.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ngo.focusCountries.isNotEmpty
                    ? '${ngo.focusCountries.length} countries'
                    : 'No countries set',
                style: GoogleFonts.workSans(
                  fontSize: 12,
                  color: AppTheme.lightTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 