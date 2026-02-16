import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/wishlist_service.dart';
import '../widgets/product_card.dart';
import '../language_provider.dart';
import '../translations.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ApiService _apiService = ApiService();
  final WishlistService _wishlistService = WishlistService();
  late Future<List<Product>> _productsFuture;
  late Future<List<String>> _categoriesFuture;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.getProducts();
    _categoriesFuture = _apiService.getCategories();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _productsFuture = _apiService.getProducts();
      _categoriesFuture = _apiService.getCategories();
    });
  }

  // Filter state
  String _selectedCategory = 'all';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _translateCategory(String category, Map<String, String> t) {
    if (category == 'all') return t['category_all']!;
    return t['category_$category'] ?? category;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageProvider(),
      builder: (context, language, _) {
        final t = Translations.get(language);

        return Scaffold(
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: t['discover_search']!,
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 18),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : Text(
                    t['discover_title']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: -0.5),
                  ),
            actions: [
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
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  context.push('/cart');
                },
              ),
            ],
          ),
          body: Column(
            children: [
              _buildCategoryFilter(t),
              Expanded(child: _buildProductGrid(t)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(Map<String, String> t) {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final categories = ['all', ...snapshot.data!];

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category;
              final displayName = _translateCategory(category, t);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: const Color(0xFF6C63FF),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(Map<String, String> t) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF6C63FF)));
          }

          if (snapshot.hasError) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                    child: Text('${t['discover_error']}: ${snapshot.error}')),
              ],
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(child: Text(t['discover_no_products']!)),
              ],
            );
          }

          final filteredProducts = snapshot.data!.where((p) {
            final matchesSearch = p.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                p.category.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesCategory =
                _selectedCategory == 'all' || p.category == _selectedCategory;
            return matchesSearch && matchesCategory;
          }).toList();

          if (filteredProducts.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        '${t['discover_no_products']} "$_searchQuery"',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: filteredProducts[index],
                wishlistService: _wishlistService,
              );
            },
          );
        },
      ),
    );
  }
}
