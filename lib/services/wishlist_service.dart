import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';

class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;

  Box<Product>? _wishlistBox;
  final ValueNotifier<List<Product>> wishlistNotifier = ValueNotifier([]);

  WishlistService._internal() {
    _initBox();
  }

  void _initBox() {
    try {
      _wishlistBox = Hive.box<Product>('wishlistBox');
      _updateNotifier();
    } catch (e) {
      debugPrint('Fout bij initialiseren van wishlistBox: $e');
      // debugPrint('Fout bij initialiseren van wishlistBox: $e');
    }
  }

  void _updateNotifier() {
    if (_wishlistBox != null) {
      final items = _wishlistBox!.values.toList();
      wishlistNotifier.value = items;
    }
  }

  bool isInWishlist(int productId) {
    if (_wishlistBox == null) return false;
    return _wishlistBox!.containsKey(productId);
  }

  Future<void> toggleWishlist(Product product) async {
    if (_wishlistBox == null) return;

    final id = product.id;
    if (isInWishlist(id)) {
      await _wishlistBox!.delete(id);
    } else {
      final productCopy = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        rating: product.rating,
        ratingCount: product.ratingCount,
      );
      await _wishlistBox!.put(id, productCopy);
    }
    _updateNotifier();
  }

  Future<void> clearWishlist() async {
    if (_wishlistBox == null) return;
    await _wishlistBox!.clear();
    _updateNotifier();
  }
}
