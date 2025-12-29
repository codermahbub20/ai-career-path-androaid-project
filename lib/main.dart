import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career App',
      debugShowCheckedModeBanner: false,

      // FORCE DARK THEME HERE
      themeMode: ThemeMode.dark,

      // Define the Dark Theme explicitly
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
            AppColors.background, // This sets the background to #121212
        primaryColor: AppColors.primaryGreen,

        // This ensures all standard text is White
        textTheme:
            GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),

        // Fix the App Bar color
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // Fix the Color Scheme
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryGreen,
          secondary: AppColors.primaryGreen,
          surface: AppColors.cardBackground,
          background: AppColors.background,
        ),

        useMaterial3: true,
      ),

      home: const OnboardingScreen(),
    );
  }
}
