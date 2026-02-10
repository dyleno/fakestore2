import 'package:fake_store/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavbarWidget(navigationShell: navigationShell),
    );
  }
}
