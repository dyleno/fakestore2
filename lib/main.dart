import 'package:fake_store/screens/settings_screen.dart';
import 'package:fake_store/screens/wishlist_screen.dart';
import 'package:fake_store/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/onboarding_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/routernav.dart';
import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<Product>('productsBox');
  await Hive.openBox<Product>('wishlistBox');

  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted =
      prefs.getBool('onboarding_completed') ?? false;
  runApp(MyApp(showOnboarding: !onboardingCompleted));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: widget.showOnboarding ? '/onboarding' : '/home',
      routes: <RouteBase>[
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(
            onComplete: () {
              context.go('/home');
            },
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return NavPage(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const DiscoverScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/wishlist',
                  builder: (context, state) => const WishlistScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider(),
      builder: (context, themeMode, child) {
        return MaterialApp.router(
          title: 'Fake Store',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2196F3),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              scrolledUnderElevation: 2,
              surfaceTintColor: Colors.white,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFF2196F3),
              unselectedItemColor: Colors.grey,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2196F3),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 2,
              surfaceTintColor: Color(0xFF1E1E1E),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E1E1E),
              selectedItemColor: Color(0xFF2196F3),
              unselectedItemColor: Colors.grey,
            ),
          ),
          themeMode: themeMode,
          routerConfig: _router,
        );
      },
    );
  }
}
