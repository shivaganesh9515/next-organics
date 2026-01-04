import 'dart:ui';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/home/domain/entities/banner.dart';

class SupabaseService {
  static const String _bannersTable = 'banners';
  static const String _productsTable = 'products';

  final SupabaseClient _client;

  SupabaseService(this._client);

  // --- BANNERS ---
  Future<List<HomeBanner>> getBanners() async {
    try {
      final response = await _client
          .from(_bannersTable)
          .select()
          .eq('is_active', true)
          .order('priority', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => _mapJsonToBanner(json)).toList();
    } catch (e) {
      // Fallback or rethrow
      return [];
    }
  }

  // Helper to map JSON to Entity
  HomeBanner _mapJsonToBanner(Map<String, dynamic> json) {
    // Convert hex string list to Color objects
    final gradientHex = List<String>.from(json['gradient_colors'] ?? []);
    final colors = gradientHex.map((hex) => _hexToColor(hex)).toList();

    return HomeBanner(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'] ?? '',
      ctaText: json['cta_text'] ?? '',
      imageUrl: json['image_url'],
      gradientColors: colors,
      targetRoute: json['target_route'] ?? '/',
    );
  }

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
