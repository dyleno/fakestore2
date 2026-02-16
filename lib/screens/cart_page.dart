import 'package:fake_store/models/cart_item.dart';
import 'package:fake_store/services/cart_service.dart';
import 'package:fake_store/models/order.dart';
import 'package:fake_store/services/order_service.dart';
import 'package:fake_store/language_provider.dart';
import 'package:fake_store/translations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageProvider(),
      builder: (context, language, _) {
        final t = Translations.get(language);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              t['cart_title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: ValueListenableBuilder<List<CartItem>>(
            valueListenable: cartService.cartNotifier,
            builder: (context, cartItems, child) {
              if (cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        t['cart_empty']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(t['wishlist_start_shopping']!),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final itemKey =
                            '${item.product.id}_${item.selectedSize ?? ''}_${item.selectedColor ?? ''}';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(item.product.image),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (item.selectedSize != null ||
                                          item.selectedColor != null)
                                        Text(
                                          '${item.selectedSize ?? ''} ${item.selectedColor != null ? '• ${item.selectedColor}' : ''}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '€${(item.product.price * item.quantity).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6C63FF),
                                              fontSize: 16,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.white10
                                                  : Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                _buildQuantityButton(
                                                  icon: Icons.remove,
                                                  onTap: () {
                                                    if (item.quantity > 1) {
                                                      cartService
                                                          .updateQuantity(
                                                              itemKey,
                                                              item.quantity -
                                                                  1);
                                                    } else {
                                                      cartService
                                                          .removeFromCart(
                                                              itemKey);
                                                    }
                                                  },
                                                  isDark: isDark,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  child: Text(
                                                    '${item.quantity}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                _buildQuantityButton(
                                                  icon: Icons.add,
                                                  onTap: () {
                                                    cartService.updateQuantity(
                                                        itemKey,
                                                        item.quantity + 1);
                                                  },
                                                  isDark: isDark,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildBottomBar(context, cartService, t),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, CartService cartService, Map<String, String> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t['cart_total']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ValueListenableBuilder<List<CartItem>>(
                  valueListenable: cartService.cartNotifier,
                  builder: (context, items, child) {
                    final total = items.fold<double>(
                      0,
                      (previousValue, element) =>
                          previousValue +
                          (element.product.price * element.quantity),
                    );
                    return Text(
                      '€${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF6C63FF),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final cartItems = cartService.cartNotifier.value;
                  final total = cartItems.fold<double>(
                    0,
                    (sum, item) => sum + (item.product.price * item.quantity),
                  );

                  final order = Order(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    items: cartItems,
                    totalAmount: total,
                    date: DateTime.now(),
                  );

                  OrderService().addOrder(order);
                  cartService.clearCart();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${t['cart_order_placed']} 🚀'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.go('/home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  t['cart_checkout']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
