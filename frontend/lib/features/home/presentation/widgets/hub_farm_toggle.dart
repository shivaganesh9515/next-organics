import 'package:flutter/material.dart';

class HubFarmToggle extends StatelessWidget {
  final bool isFarmMode;
  final ValueChanged<bool> onModeChanged;

  const HubFarmToggle({
    super.key,
    required this.isFarmMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            // HUB STORE TAB
            Expanded(
              child: GestureDetector(
                onTap: () => onModeChanged(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: !isFarmMode ? const Color(0xFF2E7D32) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: !isFarmMode 
                        ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Hub Store',
                    style: TextStyle(
                      color: !isFarmMode ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            
            // FARMS TAB
            Expanded(
              child: GestureDetector(
                onTap: () => onModeChanged(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isFarmMode ? const Color(0xFF2E7D32) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isFarmMode
                        ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Farms',
                    style: TextStyle(
                      color: isFarmMode ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
