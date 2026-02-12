import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  Box<CartItem>? _cartBox;
  final ValueNotifier<List<CartItem>> cartNotifier = ValueNotifier([]);

  CartService._internal() {
    _initBox();
  }

  void _initBox() {
    try {
      _cartBox = Hive.box<CartItem>('cartBox');
      _updateNotifier();
    } catch (e) {
      debugPrint('Error initializing cartBox: $e');
    }
  }

  void _updateNotifier() {
    if (_cartBox != null) {
      cartNotifier.value = _cartBox!.values.toList();
    }
  }

  Future<void> addToCart(Product product,
      {int quantity = 1, String? size, String? color}) async {
    if (_cartBox == null) return;

    final String key = '${product.id}_${size ?? ''}_${color ?? ''}';

    if (_cartBox!.containsKey(key)) {
      final existingItem = _cartBox!.get(key)!;
      existingItem.quantity += quantity;
      await existingItem.save();
    } else {
      final newItem = CartItem(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      );
      await _cartBox!.put(key, newItem);
    }
    _updateNotifier();
  }

  Future<void> removeFromCart(String key) async {
    if (_cartBox == null) return;
    await _cartBox!.delete(key);
    _updateNotifier();
  }

  Future<void> updateQuantity(String key, int newQuantity) async {
    if (_cartBox == null || newQuantity < 1) return;
    final item = _cartBox!.get(key);
    if (item != null) {
      item.quantity = newQuantity;
      await item.save();
      _updateNotifier();
    }
  }

  Future<void> clearCart() async {
    if (_cartBox == null) return;
    await _cartBox!.clear();
    _updateNotifier();
  }

  double get totalAmount {
    if (_cartBox == null) return 0.0;
    return _cartBox!.values
        .fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  int get itemCount {
    if (_cartBox == null) return 0;
    return _cartBox!.values.fold(0, (sum, item) => sum + item.quantity);
  }
}
