import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/entities/product.dart';

class FavouritesState {
  final List<Product> favourites;

  FavouritesState({
    this.favourites = const [],
  });

  FavouritesState copyWith({
    List<Product>? favourites,
  }) {
    return FavouritesState(
      favourites: favourites ?? this.favourites,
    );
  }

  bool isFavourite(String productId) {
    return favourites.any((p) => p.id == productId);
  }
}

class FavouritesNotifier extends StateNotifier<FavouritesState> {
  FavouritesNotifier() : super(FavouritesState());

  void toggleFavourite(Product product) {
    if (state.isFavourite(product.id)) {
      // Remove from favourites
      state = state.copyWith(
        favourites: state.favourites.where((p) => p.id != product.id).toList(),
      );
    } else {
      // Add to favourites
      state = state.copyWith(
        favourites: [...state.favourites, product],
      );
    }
  }

  void removeFavourite(String productId) {
    state = state.copyWith(
      favourites: state.favourites.where((p) => p.id != productId).toList(),
    );
  }

  void clearFavourites() {
    state = FavouritesState();
  }
}

final favouritesProvider =
    StateNotifierProvider<FavouritesNotifier, FavouritesState>((ref) {
  return FavouritesNotifier();
});
