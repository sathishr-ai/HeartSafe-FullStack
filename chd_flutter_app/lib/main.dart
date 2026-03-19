// ─────────────────────────────────────────────────────────────────────────────
// main.dart – App entry point
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/prediction_screen.dart';
import 'screens/followup_screen.dart';
import 'screens/analytics_screen.dart';
import 'services/api_service.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar for edge-to-edge feel
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Check if already logged in
  final isLoggedIn = await ApiService.instance.isLoggedIn();

  runApp(HeartSafeApp(initialRoute: isLoggedIn ? '/home' : '/login'));
}

class HeartSafeApp extends StatelessWidget {
  final String initialRoute;
  const HeartSafeApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeartSafe',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,

      // ── Premium Dark Theme ──────────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.cyan,
          secondary: AppColors.indigo,
          surface: AppColors.bgCard,
          error: AppColors.danger,
        ),
        scaffoldBackgroundColor: AppColors.bgDark,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.textSecondary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgCard.withValues(alpha: 0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      // ── Routes ─────────────────────────────────────────────────────────
      initialRoute: initialRoute,
      routes: {
        '/login':   (_) => const LoginScreen(),
        '/home':    (_) => const HomeScreen(),
        '/predict': (_) => const PredictionScreen(),
        '/followup':(_) => const FollowupScreen(),
        '/analytics':(_) => const AnalyticsScreen(),
      },
    );
  }
}
