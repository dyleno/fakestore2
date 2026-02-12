import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: _wishlistService.wishlistNotifier,
      builder: (context, wishlist, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Mijn Favorieten',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  letterSpacing: -0.5),
            ),
            actions: wishlist.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_outlined,
                          color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Verlanglijst leegmaken?'),
                            content: const Text(
                                'Weet je zeker dat je alle items wilt verwijderen?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annuleer')),
                              TextButton(
                                  onPressed: () {
                                    _wishlistService.clearWishlist();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Ja, wis alles',
                                      style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                      },
                    ),
                  ]
                : null,
          ),
          body: wishlist.isEmpty
              ? _buildEmptyWishlist()
              : _buildWishlistGrid(wishlist),
        );
      },
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_outline,
                  size: 80, color: Color(0xFF2196F3)),
            ),
            const SizedBox(height: 32),
            const Text(
              'Je verlanglijst is nog leeg',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            Text(
              'Bewaar je favoriete items hier om ze later gemakkelijk terug te vinden.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Ontdek items',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
        childAspectRatio: 0.7,
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
