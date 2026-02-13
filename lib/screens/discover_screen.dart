import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/wishlist_service.dart';
import '../widgets/product_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ApiService _apiService = ApiService();
  final WishlistService _wishlistService = WishlistService();
  late final Future<List<Product>> _productsFuture = _apiService.getProducts();
  late final Future<List<String>> _categoriesFuture =
      _apiService.getCategories();

  String _selectedCategory = 'Alle';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
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
            : const Text(
                'Ontdek Shop',
                style: TextStyle(
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
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              context.push('/cart');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final categories = ['Alle', ...snapshot.data!];

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    category[0].toUpperCase() + category.substring(1),
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
                  backgroundColor: Colors.grey[100],
                  selectedColor: const Color(0xFF6C63FF),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF6C63FF)
                          : Colors.transparent,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
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
          final matchesSearch =
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  p.category.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesCategory =
              _selectedCategory == 'Alle' || p.category == _selectedCategory;
          return matchesSearch && matchesCategory;
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
            return ProductCard(
              product: products[index],
              wishlistService: _wishlistService,
            );
          },
        );
      },
    );
  }
}
