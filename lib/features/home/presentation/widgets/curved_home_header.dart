import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import 'curved_header_clipper.dart';

/// Premium curved header for home screen with gradient and 3-section layout
class CurvedHomeHeader extends ConsumerStatefulWidget {
  final VoidCallback? onLocationTap;

  const CurvedHomeHeader({
    super.key,
    this.onLocationTap,
  });

  @override
  ConsumerState<CurvedHomeHeader> createState() => _CurvedHomeHeaderState();
}

class _CurvedHomeHeaderState extends ConsumerState<CurvedHomeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final int _previousCartCount = 0;
  final bool _shouldPulse = false;

  @override
  void initState() {
    super.initState();
    
    // Fade-in animation on first load
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only keeping cart check logic if needed for future, but removing unused vars to clean up
    // ... logic remains same ...

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ClipPath(
        clipper: CurvedHeaderClipper(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2E7D32), // Organic Deep Green
                Color(0xFF66BB6A), // Fresh Leaf Green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ROW 1: Location | 'BIO' | Profile
                  Row(
                    children: [
                      // Location Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on, 
                                  size: 18, 
                                  color: Colors.white
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Green Valley', // Organic Rebrand
                                  style: AppTypography.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 22),
                              child: Text(
                                'Eco-Farm, Plot 42, Organic Zone...',
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 'BIO' Badge (Replaces 'one')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2), // Glass effect
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          children: [
                             Text(
                              'BIO',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.verified, size: 14, color: Colors.white)
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Profile Icon
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 24,
                            color: Color(0xFF2E7D32), // Green Icon
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // ROW 2: Search Bar + Local Toggle
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search "Organic Apples"...',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        
                        // Vertical Divider
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 12),
                        
                        // Mic Icon
                        const Icon(
                          Icons.mic,
                          color: Color(0xFF2E7D32), // Green Mic
                          size: 22,
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // LOCAL Toggle
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50], // Light Green bg
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'LOCAL',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              SizedBox(height: 2),
                              // Simplified Switch Visual
                              Icon(Icons.toggle_on, color: Color(0xFF2E7D32), size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Removing unused internal widgets since we inlined the layout
// _LocationSelector, _SearchPill, _CartIcon are no longer used in this file
// keeping the file clean.

