import 'package:fake_store/services/cart_service.dart';
import 'package:fake_store/services/wishlist_service.dart';
import 'package:fake_store/services/order_service.dart';
import 'package:fake_store/models/order.dart';
import 'package:fake_store/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _storageSize = '45.2 MB';

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildSectionHeader('APPEARANCE'),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeProvider,
                builder: (context, themeMode, _) {
                  return _buildSettingsItem(
                    icon: Icons.dark_mode_outlined,
                    iconColor: const Color(0xFF6C63FF),
                    title: 'Dark Mode',
                    isDark: isDark,
                    trailing: Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (bool val) {
                        themeProvider
                            .setTheme(val ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeThumbColor: const Color(0xFF6C63FF),
                    ),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('RECENTE AANKOPEN'),
          ValueListenableBuilder<List<Order>>(
            valueListenable: OrderService().ordersNotifier,
            builder: (context, orders, _) {
              if (orders.isEmpty) {
                return _buildSettingsCard(
                  isDark: isDark,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.shopping_bag_outlined,
                                color: Colors.grey.withOpacity(0.5), size: 32),
                            const SizedBox(height: 8),
                            const Text(
                              'Nog geen bestellingen',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: orders.take(3).map((order) {
                  return Column(
                    children: [
                      _buildSettingsCard(
                        isDark: isDark,
                        children: [
                          _buildSettingsItem(
                            icon: Icons.receipt_long_outlined,
                            iconColor: const Color(0xFF6C63FF),
                            title:
                                'Bestelling #${order.id.substring(order.id.length - 5)}',
                            isDark: isDark,
                            trailing: Text(
                              '€${order.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                            onTap: () {
                              _showOrderDetails(context, order, isDark);
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 56, bottom: 12),
                            child: Text(
                              DateFormat('dd MMM yyyy, HH:mm')
                                  .format(order.date),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('DATA & STORAGE'),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildSettingsItem(
                icon: Icons.cloud_outlined,
                iconColor: const Color(0xFF6C63FF),
                title: 'Used Storage',
                isDark: isDark,
                trailing: Text(
                  _storageSize,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                onTap: () {},
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: isDark ? Colors.white10 : Colors.black12),
              _buildSettingsItem(
                icon: Icons.delete_outline,
                iconColor: Colors.red,
                title: 'Clear Cache',
                titleColor: Colors.red,
                isDark: isDark,
                trailing: const Icon(Icons.chevron_right,
                    color: Colors.grey, size: 20),
                onTap: () {
                  PaintingBinding.instance.imageCache.clear();
                  PaintingBinding.instance.imageCache.clearLiveImages();

                  setState(() {
                    _storageSize = '0.0 MB';
                  });

                  ThemeProvider().setTheme(ThemeMode.system);

                  WishlistService().clearWishlist();
                  CartService().clearCart();
                  OrderService().clearOrders();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: Colors.white),
                          const SizedBox(width: 12),
                          const Text('Cache, Theme & Wishlist cleared'),
                        ],
                      ),
                      backgroundColor: Colors.green.shade800,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8, right: 16),
            child: Text(
              'Clearing the cache can cause light mode to be restored and the shopping cart/whishlist to be emptied.',
              style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('ABOUT'),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              _buildSettingsItem(
                icon: Icons.info_outline,
                iconColor: Colors.green,
                title: 'Version',
                isDark: isDark,
                trailing: const Text(
                  '2.1.0 (Build 402)',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                onTap: () {},
              ),
              Divider(
                  height: 1,
                  indent: 56,
                  color: isDark ? Colors.white10 : Colors.black12),
              _buildSettingsItem(
                title: 'Privacy Policy',
                isDark: isDark,
                trailing: const Icon(Icons.chevron_right,
                    color: Colors.grey, size: 20),
                showIconBackground: false,
                onTap: () {},
              ),
              Divider(
                  height: 1,
                  indent: 16,
                  color: isDark ? Colors.white10 : Colors.black12),
              _buildSettingsItem(
                title: 'Terms of Service',
                isDark: isDark,
                trailing: const Icon(Icons.chevron_right,
                    color: Colors.grey, size: 20),
                showIconBackground: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 48),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      {required List<Widget> children, required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    IconData? icon,
    Color? iconColor,
    required String title,
    Widget? trailing,
    Color? titleColor,
    bool showIconBackground = true,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: showIconBackground
                      ? iconColor?.withValues(alpha: 0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
            ] else
              const SizedBox(width: 42),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: titleColor ?? (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 12),
        const Text(
          'ShopMobile App',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '© 2024 Commerce Inc.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showOrderDetails(BuildContext context, Order order, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bestelling Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.product.title}',
                            style: TextStyle(
                                color:
                                    isDark ? Colors.white70 : Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '€${(item.product.price * item.quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Totaal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '€${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
