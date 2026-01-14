import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../products/presentation/providers/products_provider.dart';

import 'dart:async';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Initialize with current query if any
    final currentQuery = ref.read(searchQueryProvider);
    if (currentQuery.isNotEmpty) {
      _searchController.text = currentQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final currentQuery = ref.watch(searchQueryProvider); // Watch for UI state

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search organic products...',
            border: InputBorder.none,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textHintDark : AppColors.textHint,
            ),
          ),
          style: AppTypography.bodyLarge.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          onChanged: _onSearchChanged,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = '';
            context.pop();
          },
        ),
        actions: [
          if (currentQuery.isNotEmpty || _searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.textSecondary),
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: currentQuery.isEmpty
          ? _buildSuggestions(isDark)
          : searchResultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => EmptyState(
                icon: Icons.error_outline,
                title: 'Search Error',
                message: 'Something went wrong. Please try again.',
                action: ElevatedButton(
                  onPressed: () => ref.refresh(searchResultsProvider),
                  child: const Text('Retry'),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    title: 'No Results',
                    message: 'No products found for "$currentQuery"',
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) =>
                      ProductCard(product: products[index]),
                );
              },
            ),
    );
  }

  Widget _buildSuggestions(bool isDark) {
    final suggestions = ['Vegetables', 'Fruits', 'Dairy', 'Rice', 'Spices'];

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: AppTypography.headingMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  _searchController.text = suggestion;
                  ref.read(searchQueryProvider.notifier).state = suggestion;
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
