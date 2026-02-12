import 'package:fake_store/screens/chat_screen.dart';
import 'package:fake_store/screens/product_detail_screen.dart';
import 'package:fake_store/screens/settings_screen.dart';
import 'package:fake_store/screens/wishlist_screen.dart';
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
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ProductAdapter());
  }
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
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => OnboardingScreen(
            onComplete: () => context.go('/home'),
          ),
        ),
        GoRoute(
          path: '/product-details',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final product = state.extra as Product;
            return ProductDetailScreen(product: product);
          },
        ),
        GoRoute(
          path: '/chat',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final product = state.extra as Product;
            return ChatScreen(product: product);
          },
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
    return MaterialApp.router(
      title: 'Fake Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
