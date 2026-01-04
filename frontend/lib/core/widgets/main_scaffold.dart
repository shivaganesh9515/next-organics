import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/widgets/floating_bottom_navigation.dart';
import 'animations/directional_page_transition.dart';

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
  int _prevIndex = 0;

  @override
  void didUpdateWidget(MainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _prevIndex = oldWidget.currentIndex;
    }
  }

  void _onNavTap(int index) {
    // Light impact is good, but let's make it consistent with the button itself
    // HapticFeedback.lightImpact(); // The NavItem handles this
    
    // Prevent navigating to same tab
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/categories');
        break;
      case 2:
        context.go('/favourites');
        break;
      case 3:
        context.go('/cart');
        break;
    }
  }

  Future<bool> _onWillPop() async {
    // If on Home tab, show exit dialog
    if (widget.currentIndex == 0) {
      return await _showExitDialog() ?? false;
    }
    // Otherwise, navigate to Home
    context.go('/home');
    return false;
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Exit App?',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to exit Next Organics?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: DirectionalPageTransition(
          reverse: widget.currentIndex < _prevIndex,
          child: KeyedSubtree(
            key: ValueKey(widget.currentIndex),
            child: widget.child,
          ),
        ),
        bottomNavigationBar: FloatingBottomNavigation(
          currentIndex: widget.currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
