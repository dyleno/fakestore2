import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';
import '../services/cart_service.dart';
import '../language_provider.dart';
import '../translations.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final WishlistService _wishlistService = WishlistService();
  late String _selectedSize;
  Color? _selectedColorTint;

  late List<String> _sizes;
  final List<Color> _colors = [
    const Color(0xFF6C63FF),
    const Color(0xFF2D3142),
    const Color(0xFFE4C1AD),
    const Color(0xFF9EA3B0),
    const Color(0xFF4CAF50),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.product.category.toLowerCase().contains('men\'s clothing') ||
        widget.product.category.toLowerCase().contains('women\'s clothing')) {
      _sizes = ['S', 'M', 'L', 'XL', 'XXL'];
    } else if (widget.product.category.contains('jewelery')) {
      _sizes = ['One Size'];
    } else if (widget.product.category.contains('electronics')) {
      _sizes = ['N/A'];
    } else {
      _sizes = ['M', 'L', 'XL'];
    }
    _selectedSize = _sizes.first;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageProvider(),
      builder: (context, language, _) {
        final t = Translations.get(language);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleAndPrice(),
                      const SizedBox(height: 16),
                      _buildRating(t),
                      const SizedBox(height: 24),
                      _buildColorSelection(t),
                      const SizedBox(height: 24),
                      _buildSizeSelection(t),
                      const SizedBox(height: 24),
                      _buildDescription(t),
                      const SizedBox(height: 24),
                      _buildSpecs(t),
                      const SizedBox(height: 32),
                      _buildReviews(t),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: _buildBottomBar(t),
        );
      },
    );
  }

  Widget _buildAppBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverAppBar(
      expandedHeight: 400,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor:
              isDark ? Colors.white10 : Colors.white.withAlpha(204),
          child: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor:
                isDark ? Colors.white10 : Colors.white.withAlpha(204),
            child: IconButton(
              icon: Icon(Icons.share_outlined,
                  color: isDark ? Colors.white : Colors.black87),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'product_image_${widget.product.id}',
          child: Container(
            color: isDark ? const Color(0xFF121212) : Colors.white,
            padding:
                const EdgeInsets.only(top: 80, bottom: 40, left: 40, right: 40),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _selectedColorTint ?? Colors.transparent,
                BlendMode.multiply,
              ),
              child: Image.network(
                widget.product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.product.title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF2D3142),
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(width: 16),
        ValueListenableBuilder(
          valueListenable: _wishlistService.wishlistNotifier,
          builder: (context, wishlist, child) {
            final isFavorite = _wishlistService.isInWishlist(widget.product.id);
            return IconButton(
              onPressed: () => _wishlistService.toggleWishlist(widget.product),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 28,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRating(Map<String, String> t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '€${widget.product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              widget.product.rating.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              '•  ${widget.product.ratingCount} ${t['product_reviews']!}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSelection(Map<String, String> t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t['product_select_color']!,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _colors.map((color) {
              final isSelected = _selectedColorTint == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedColorTint == color) {
                      _selectedColorTint = null;
                    } else {
                      _selectedColorTint = color;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: color,
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelection(Map<String, String> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t['product_size']!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            TextButton(
              onPressed: () => _showSizeGuide(context, t),
              child: Text(
                t['product_size_guide']!,
                style: const TextStyle(
                    color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _sizes.map((size) {
              final isSelected = _selectedSize == size;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6C63FF)
                        : (isDark ? Colors.white12 : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black87),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showSizeGuide(BuildContext context, Map<String, String> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t['product_size_guide_title']!,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t['product_size_guide_subtitle']!,
                    style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  _buildSizeTable(t),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D3142),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(t['product_size_guide_close']!),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSizeTable(Map<String, String> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClothing =
        widget.product.category.toLowerCase().contains('clothing');

    if (!isClothing) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          t['product_size_guide_no_table']!,
          style: TextStyle(
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white70 : Colors.black),
        ),
      );
    }

    return Table(
      border: TableBorder.symmetric(
          inside:
              BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!)),
      children: [
        _buildTableRow([
          t['product_size_table_size']!,
          t['product_size_table_chest']!,
          t['product_size_table_length']!
        ], isHeader: true, t: t),
        _buildTableRow(['S', '92-96', '68-70']),
        _buildTableRow(['M', '96-100', '70-72']),
        _buildTableRow(['L', '100-104', '72-74']),
        _buildTableRow(['XL', '104-108', '74-76']),
        _buildTableRow(['XXL', '108-112', '76-78']),
      ],
    );
  }

  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, Map<String, String>? t}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            cell,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader
                  ? (isDark ? Colors.white : Colors.black)
                  : (isDark ? Colors.white70 : Colors.grey[700]),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescription(Map<String, String> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t['product_description']!,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.description,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white70 : Colors.grey[600],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecs(Map<String, String> t) {
    return Row(
      children: [
        _buildSpecItem(Icons.info_outline, t['product_specs_title']!,
            t['product_specs_quality']!, t),
        const SizedBox(width: 16),
        _buildSpecItem(
            Icons.verified_user_outlined,
            t['product_specs_warranty']!,
            t['product_specs_warranty_value']!,
            t),
      ],
    );
  }

  Widget _buildSpecItem(
      IconData icon, String title, String value, Map<String, String> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: isDark ? Colors.white10 : Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF6C63FF), size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3142)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Map<String, String> t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            InkWell(
              onTap: () {
                context.push('/chat', extra: widget.product);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.chat_bubble_outline,
                    color: isDark ? Colors.white : const Color(0xFF2D3142)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  CartService().addToCart(
                    widget.product,
                    size: _selectedSize,
                    color: _selectedColorTint != null
                        ? 'Color ${_colors.indexOf(_selectedColorTint!) + 1}'
                        : null,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t['product_added_to_cart']!),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      t['product_add_to_cart']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviews(Map<String, String> t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t['product_reviews_title']!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
            ),
            Text(
              t['product_reviews_view_all']!,
              style: const TextStyle(
                  color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildReviewItem('Daan V.', 5.0,
            'Echt een top aankoop! De kwaliteit van de ${widget.product.category} is boven verwachting.'),
        _buildReviewItem('Sophie de B.', 4.5,
            'Snelle levering en het product ziet er precies uit als op de foto.'),
        _buildReviewItem('Lars K.', 4.0,
            'Goede prijs-kwaliteitverhouding. Ik ga hier vaker bestellen.'),
      ],
    );
  }

  Widget _buildReviewItem(String name, double rating, String comment) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black)),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(rating.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
                fontSize: 13,
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
