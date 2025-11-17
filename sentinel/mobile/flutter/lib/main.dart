import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'services/api_service.dart';

import 'screens/login_screen.dart';
import 'screens/pairing_screen.dart';
import 'screens/scores_screen.dart';
import 'screens/score_details_screen.dart';
import 'screens/trips_screen.dart';
import 'screens/trip_detail_screen.dart';
import 'screens/rewards_screen.dart';

void main() {
  runApp(const SentinelApp());
}

class SentinelApp extends StatelessWidget {
  const SentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider(apiService: apiService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sentinel',
        theme: _buildSentinelTheme(),
        initialRoute: '/',
        routes: {
          '/': (ctx) {
            final auth = Provider.of<AuthProvider>(ctx);
            if (auth.user == null) return const LoginScreen();
            return const MainTabs();
          },
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          PairingScreen.routeName: (ctx) => const PairingScreen(),
          TripsScreen.routeName: (ctx) => const TripsScreen(),
          TripDetailScreen.routeName: (ctx) => const TripDetailScreen(),
          ScoresScreen.routeName: (ctx) => const ScoresScreen(),
          ScoreDetailsScreen.routeName: (ctx) => const ScoreDetailsScreen(),
          RewardsScreen.routeName: (ctx) => const RewardsScreen(),
        },
      ),
    );
  }

  /// THEME COMPATIBLE WITH FLUTTER 3.38
  ThemeData _buildSentinelTheme() {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
    );

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.dark,
      ),

      // ---------- BACKGROUND ----------
      scaffoldBackgroundColor: const Color(0xFF050816),

      // ---------- FONTS ----------
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),

      // ---------- APPBAR ----------
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // ---------- CARD ----------
      cardTheme: const CardThemeData(
        color: Color(0x0FFFFFFF), // 6% opacity
        elevation: 0,
        margin: EdgeInsets.all(12),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // ---------- NAVIGATION BAR ----------
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF0A0F1F),
        indicatorColor: Color(0xFF2563EB),
        surfaceTintColor: Colors.transparent,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // ---------- PAGE TRANSITIONS ----------
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const ScoresScreen(),
    const TripsScreen(),
    const RewardsScreen(),
    const PairingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.score),
            label: 'Scores',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Trajets',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard),
            label: 'Eco-points',
          ),
          NavigationDestination(
            icon: Icon(Icons.device_hub),
            label: 'Module',
          ),
        ],
      ),
    );
  }
}
