import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/widgets/floating_bottom_navigation.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    this.currentIndex = 0,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  void _onNavTap(int index) {
    HapticFeedback.lightImpact();
    
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/category/all');
        break;
      case 2:
        context.go('/favourites');
        break;
      case 3:
        context.go('/cart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows content to extend beneath floating nav
      body: widget.child,
      bottomNavigationBar: FloatingBottomNavigation(
        currentIndex: widget.currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
