import 'package:flutter/material.dart';
import 'package:fake_store/data/notifiers.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/wishlist_service.dart';
import '../widgets/navbar_widget.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ApiService _apiService = ApiService();
  final WishlistService _wishlistService = WishlistService();
  late Future<List<Product>> _productsFuture;

  // Search state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.getProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 2,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: _isSearching && selectedPage == 0
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Zoek producten...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 18),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : Text(
                    selectedPage == 0
                        ? 'Ontdek Shop'
                        : (selectedPage == 1
                            ? 'Mijn Favorieten'
                            : 'Instellingen'),
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: -0.5),
                  ),
            actions: selectedPage == 1
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
                : [
                    if (selectedPage == 0)
                      IconButton(
                        icon: Icon(_isSearching ? Icons.close : Icons.search),
                        onPressed: () {
                          setState(() {
                            if (_isSearching) {
                              _isSearching = false;
                              _searchController.clear();
                              _searchQuery = '';
                            } else {
                              _isSearching = true;
                            }
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Winkelwagen komt binnenkort! ❤️'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
          ),
          body: _buildPage(selectedPage),
          bottomNavigationBar: const NavbarWidget(),
        );
      },
    );
  }

  Widget _buildPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return _buildProductGrid();
      case 1:
        return _buildWishlistPage();
      case 2:
        return const Center(child: Text('Instellingen pagina'));
      default:
        return _buildProductGrid();
    }
  }

  Widget _buildProductGrid() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Fout: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Geen producten gevonden.'));
        }

        final allProducts = snapshot.data!;
        final products = allProducts.where((p) {
          return p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        if (products.isEmpty && _searchQuery.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Geen resultaten voor "$_searchQuery"',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductCard(product);
          },
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Hero(
                    tag: 'product_image_${product.id}',
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '€${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.amber),
                            Text(
                              ' ${product.rating}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          '${product.ratingCount} reviews',
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: ValueListenableBuilder(
              valueListenable: _wishlistService.wishlistNotifier,
              builder: (context, wishlist, child) {
                final isFavorite = _wishlistService.isInWishlist(product.id);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 22,
                    ),
                    onPressed: () async {
                      await _wishlistService.toggleWishlist(product);
                      final isNowFavorite =
                          _wishlistService.isInWishlist(product.id);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  isNowFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    isNowFavorite
                                        ? 'Item toegevoegd aan wishlist'
                                        : 'Item verwijderd uit wishlist',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: isNowFavorite
                                ? const Color(0xFF6C63FF)
                                : Colors.black87,
                            action: isNowFavorite
                                ? SnackBarAction(
                                    label: 'BEKIJK',
                                    textColor: Colors.white,
                                    onPressed: () =>
                                        selectedPageNotifier.value = 1,
                                  )
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistPage() {
    return ValueListenableBuilder<List<Product>>(
      valueListenable: _wishlistService.wishlistNotifier,
      builder: (context, wishlist, child) {
        if (wishlist.isEmpty) {
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
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_outline,
                        size: 80, color: Color(0xFF6C63FF)),
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
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => selectedPageNotifier.value = 0,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Ontdek items',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
            final product = wishlist[index];
            return _buildProductCard(product);
          },
        );
      },
    );
  }
}
