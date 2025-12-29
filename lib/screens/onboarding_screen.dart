import 'package:ai_carrer_path/models/onboarding_page_model.dart';
import 'package:ai_carrer_path/utils/app_theme.dart';
import 'package:ai_carrer_path/widgets/custom_button.dart';
import 'package:ai_carrer_path/widgets/onboarding_page_content.dart';
import 'package:ai_carrer_path/widgets/page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      title: 'Discover Jobs',
      description:
          'Let our AI analyze your unique skills to find opportunities that fit your career roadmap perfectly.',
      icon: Icons.search,
    ),
    OnboardingPageModel(
      title: 'Personalized',
      titleHighlight: 'Career Roadmap',
      description:
          'Discover a path tailored just for you. Our AI analyzes your skills to suggest the perfect next steps for your future.',
      icon: Icons.trending_up,
    ),
    OnboardingPageModel(
      title: 'Master New Skills',
      description:
          'Get personalized course recommendations powered by AI to fill the gaps in your resume.',
      icon: Icons.code,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/signup'),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(page: _pages[index]);
                },
              ),
            ),

            // Page Indicator
            PageIndicator(currentIndex: _currentPage, pageCount: _pages.length),

            const SizedBox(height: 40),

            // Get Started / Sign Up Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: _currentPage < 2 ? 'Get Started' : 'Sign Up',
                showArrow: _currentPage == 2,
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushNamed(context, '/signup');
                  }
                },
                isPrimary: true,
              ),
            ),

            // Login Link
            if (_currentPage == 1 || _currentPage == 2)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: CustomButton(
                  text: 'Login',
                  isPrimary: false,
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  showArrow: false,
                ),
              )
            else
              const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
