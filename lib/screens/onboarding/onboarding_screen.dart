import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              _OnboardingPage(
                title: 'Discover Jobs',
                description:
                    'Let our AI analyze your unique skills to find opportunities that fit your career roadmap perfectly.',
                // Replace with your asset image
                imagePath: 'assets/images/onboarding_1.png',
              ),
              _OnboardingPage(
                title: 'Personalized Career Roadmap',
                description:
                    'Discover a path tailored just for you. Our AI analyzes your skills to suggest the perfect next steps.',
                imagePath: 'assets/images/onboarding_2.png',
              ),
              _OnboardingPage(
                title: 'Master New Skills',
                description:
                    'Get personalized course recommendations powered by AI to fill the gaps in your resume.',
                imagePath: 'assets/images/onboarding_3.png',
              ),
            ],
          ),

          // Bottom controls
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryGreen,
                    dotColor: Colors.grey,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Buttons
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                CustomButton(
                  text: onLastPage ? 'Get Started' : 'Next',
                  onPressed: () {
                    if (onLastPage) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    } else {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                  showArrow: false,
                  isPrimary: true,
                ),
                if (!onLastPage)
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text("Skip",
                        style: TextStyle(color: Colors.white)),
                  )
                else
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text("Login",
                        style: TextStyle(color: Colors.white)),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Placeholder for image if asset is missing
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.image, size: 100, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Text(title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
