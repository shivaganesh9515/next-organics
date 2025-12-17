import 'package:flutter/material.dart';

class FilterSortBar extends StatelessWidget {
  const FilterSortBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildChip('Filter', icon: Icons.tune),
            const SizedBox(width: 12),
            _buildChip('Sort By', icon: Icons.keyboard_arrow_down, isTrailingIcon: true),
            const SizedBox(width: 12),
            _buildChip('Pesticide Free'), 
            const SizedBox(width: 12),
            _buildChip('Fresh Harvest'),
            const SizedBox(width: 12),
            _buildChip('4.5+ Rated'),
            const SizedBox(width: 12),
            _buildChip('Gluten Free'),
            const SizedBox(width: 12),
            _buildChip('Local Farms'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {IconData? icon, bool isTrailingIcon = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && !isTrailingIcon) ...[
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (icon != null && isTrailingIcon) ...[
            const SizedBox(width: 6),
            Icon(icon, size: 16, color: Colors.black87),
          ],
        ],
      ),
    );
  }
}
