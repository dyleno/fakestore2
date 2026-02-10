import 'package:flutter/material.dart';
import 'package:fake_store/data/notifiers.dart';
import 'package:lottie/lottie.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> with TickerProviderStateMixin {
  late final AnimationController _wishlistController;
  late final AnimationController _settingsController;

  @override
  void initState() {
    super.initState();
    _wishlistController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _wishlistController.dispose();
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF6C63FF).withValues(alpha: 0.1),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xFF6C63FF)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: SizedBox(
                height: 24,
                width: 24,
                child: Lottie.asset(
                  'lotties/wishlist.json',
                  controller: _wishlistController,
                  onLoaded: (composition) {
                    _wishlistController.duration = composition.duration;
                    if (selectedPage == 1) {
                      _wishlistController.forward(from: 1.0);
                    }
                  },
                ),
              ),
              label: 'Wishlist',
            ),
            NavigationDestination(
              icon: SizedBox(
                height: 24,
                width: 24,
                child: Lottie.asset(
                  'lotties/settings.json',
                  controller: _settingsController,
                  onLoaded: (composition) {
                    _settingsController.duration = composition.duration;
                    if (selectedPage == 2) {
                      _settingsController.forward(from: 1.0);
                    }
                  },
                ),
              ),
              label: 'Settings',
            ),
          ],
          onDestinationSelected: (int value) {
            
            if (value == 1) {
              _wishlistController.forward(from: 0.0);
            } else if (selectedPage == 1) {
              _wishlistController.reverse(from: 1.0);
            }

            if (value == 2) {
              _settingsController.forward(from: 0.0);
            } else if (selectedPage == 2) {
              _settingsController.reverse(from: 1.0);
            }

            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}