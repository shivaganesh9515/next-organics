import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/widgets/animations/fade_in_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/mock_address_datasource.dart';
import '../../domain/entities/address.dart';

final mockAddressDataSourceProvider = Provider((ref) => MockAddressDataSource());

final addressesProvider = FutureProvider<List<AddressEntity>>((ref) async {
  final dataSource = ref.watch(mockAddressDataSourceProvider);
  return dataSource.getAddresses();
});

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return MainScaffold(
      currentIndex: 4, 
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Addresses', style: AppTypography.headingMedium),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.primary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Add Address coming soon!')),
                );
              },
            ),
          ],
        ),
        body: addressesAsync.when(
          data: (addresses) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return FadeInSlide(
                delay: index * 0.1,
                child: _AddressCard(address: address),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, __) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressEntity address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault ? Border.all(color: AppColors.primary, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              address.label == 'Home' ? Icons.home : Icons.work,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      address.label,
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (address.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address.addressLine,
                  style: AppTypography.bodyMedium,
                ),
                Text(
                  '${address.city}, ${address.zipCode}',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}
