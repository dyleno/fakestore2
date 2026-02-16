import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';
import '../widgets/product_card.dart';
import '../language_provider.dart';
import '../translations.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageProvider(),
      builder: (context, language, _) {
        final t = Translations.get(language);

        return ValueListenableBuilder<List<Product>>(
          valueListenable: _wishlistService.wishlistNotifier,
          builder: (context, wishlist, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  t['wishlist_title']!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      letterSpacing: -0.5),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: t['wishlist_go_to_cart'],
                    onPressed: () => context.push('/cart'),
                  ),
                  if (wishlist.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_outlined,
                          color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(t['wishlist_clear_title']!),
                            content: Text(t['wishlist_clear_message']!),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(t['wishlist_clear_cancel']!)),
                              TextButton(
                                onPressed: () {
                                  _wishlistService.clearWishlist();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  t['wishlist_clear_confirm']!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
              body: wishlist.isEmpty
                  ? _buildEmptyWishlist(t)
                  : _buildWishlistGrid(wishlist),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyWishlist(Map<String, String> t) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border_rounded,
                  size: 80, color: Color(0xFF6C63FF)),
            ),
            const SizedBox(height: 32),
            Text(
              t['wishlist_empty']!,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            Text(
              t['wishlist_empty_subtitle']!,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(t['wishlist_start_shopping']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistGrid(List<Product> wishlist) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: wishlist.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: wishlist[index],
          wishlistService: _wishlistService,
        );
      },
    );
  }
}
