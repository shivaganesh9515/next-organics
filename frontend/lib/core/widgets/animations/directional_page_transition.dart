import 'package:flutter/material.dart';

class DirectionalPageTransition extends StatefulWidget {
  final Widget child;
  final bool reverse; // true = slide previous tab (Left to Right)

  const DirectionalPageTransition({
    super.key,
    required this.child,
    this.reverse = false,
  });

  @override
  State<DirectionalPageTransition> createState() => _DirectionalPageTransitionState();
}

class _DirectionalPageTransitionState extends State<DirectionalPageTransition> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Animations for FORWARD (Navigating to higher index)
  // Enter: From Right
  late Animation<Offset> _slideInRight;
  // Exit: To Left (Parallax)
  late Animation<Offset> _slideOutLeft;
  
  // Animations for REVERSE (Navigating to lower index)
  // Enter: From Left (Parallax)
  late Animation<Offset> _slideInLeft;
  // Exit: To Right
  late Animation<Offset> _slideOutRight;

  Widget? _oldChild;
  Widget? _newChild;
  bool _reverse = false;

  @override
  void initState() {
    super.initState();
    _newChild = widget.child;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Slower, more premium
    );
    
    const curve = Curves.fastOutSlowIn; // Premium ease

    _slideInRight = Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: curve));
        
    _slideOutLeft = Tween<Offset>(begin: Offset.zero, end: const Offset(-0.3, 0))
        .animate(CurvedAnimation(parent: _controller, curve: curve));

    _slideInLeft = Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: curve));
        
    _slideOutRight = Tween<Offset>(begin: Offset.zero, end: const Offset(1.0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: curve));

    // Initially complete
    _controller.value = 1.0; 
  }

  @override
  void didUpdateWidget(DirectionalPageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child.key != oldWidget.child.key) {
      _oldChild = oldWidget.child;
      _newChild = widget.child;
      _reverse = widget.reverse;
      
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // OLD CHILD (Exiting)
        if (_oldChild != null && _controller.isAnimating)
          SlideTransition(
            position: _reverse ? _slideOutRight : _slideOutLeft,
            child: Container(
              // Scrim for parallax element
              foregroundDecoration: BoxDecoration(
                color: Colors.black.withOpacity(_reverse ? 0.0 : (0.2 * (1 - _controller.value))),
              ),
              child: _oldChild,
            ),
          ),
          
        // NEW CHILD (Entering)
        SlideTransition(
          position: _reverse ? _slideInLeft : _slideInRight,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                // Shadow for the top layer
                if (!_reverse || _controller.isAnimating) 
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(-10, 0),
                  ),
              ],
            ),
            child: _newChild,
          ),
        ),
      ],
    );
  }
}
