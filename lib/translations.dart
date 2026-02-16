import 'language_provider.dart';

class Translations {
  static Map<String, String> get(AppLanguage language) {
    return language == AppLanguage.dutch ? _dutch : _english;
  }

  static final Map<String, String> _dutch = {
    // Navigation
    'nav_home': 'Home',
    'nav_wishlist': 'Verlanglijst',
    'nav_chat': 'Chat',
    'nav_settings': 'Instellingen',

    // Discover Screen
    'discover_title': 'Ontdek Shop',
    'discover_search': 'Zoek producten...',
    'discover_error': 'Fout bij het laden',
    'discover_no_products': 'Geen producten gevonden.',

    // Categories
    'category_all': 'Alle',
    'category_electronics': 'Elektronica',
    'category_jewelery': 'Sieraden',
    'category_men\'s clothing': 'Herenkleding',
    'category_women\'s clothing': 'Dameskleding',

    // Wishlist Screen
    'wishlist_title': 'Mijn Favorieten',
    'wishlist_empty': 'Je verlanglijst is nog leeg',
    'wishlist_empty_subtitle':
        'Bewaar je favoriete items hier om ze later gemakkelijk terug te vinden.',
    'wishlist_start_shopping': 'Ontdek items',
    'wishlist_remove': 'Verwijderen',
    'wishlist_add_to_cart': 'Toevoegen aan Winkelwagen',
    'wishlist_go_to_cart': 'Naar Winkelwagen',
    'wishlist_clear_title': 'Verlanglijst leegmaken?',
    'wishlist_clear_message':
        'Weet je zeker dat je alle items wilt verwijderen?',
    'wishlist_clear_cancel': 'Annuleer',
    'wishlist_clear_confirm': 'Ja, wis alles',

    // Cart Page
    'cart_title': 'Winkelwagen',
    'cart_empty': 'Je winkelwagen is leeg',
    'cart_total': 'Totaal',
    'cart_checkout': 'Afrekenen',
    'cart_order_placed': 'Bestelling geplaatst!',

    // Product Detail Screen
    'product_reviews': 'reviews',
    'product_select_color': 'SELECTEER KLEUR',
    'product_size': 'MAAT',
    'product_size_guide': 'Size Guide',
    'product_size_guide_title': 'Size Guide',
    'product_size_guide_subtitle': 'Alle afmetingen zijn in centimeters (cm).',
    'product_size_guide_close': 'Sluiten',
    'product_size_guide_no_table':
        'Voor dit product is geen specifieke maattabel beschikbaar.',
    'product_size_table_size': 'Maat',
    'product_size_table_chest': 'Borst',
    'product_size_table_length': 'Lengte',
    'product_description': 'Beschrijving',
    'product_specs_title': 'SPECS',
    'product_specs_quality': 'Hoogwaardig',
    'product_specs_warranty': 'GARANTIE',
    'product_specs_warranty_value': '2 Jaar',
    'product_add_to_cart': 'In mijn mandje',
    'product_added_to_cart': 'Toegevoegd aan mandjes! 🛍️',
    'product_reviews_title': 'Reviews',
    'product_reviews_view_all': 'Bekijk alles',

    // Settings Screen
    'settings_title': 'Instellingen',
    'settings_appearance': 'WEERGAVE',
    'settings_dark_mode': 'Donkere modus',
    'settings_language': 'Taal',
    'settings_recent_orders': 'RECENTE BESTELLINGEN',
    'settings_no_orders': 'Nog geen bestellingen',
    'settings_order': 'Bestelling',
    'settings_order_details': 'Besteldetails',
    'settings_total': 'Totaal',
    'settings_data_storage': 'DATA & OPSLAG',
    'settings_used_storage': 'Gebruikte opslag',
    'settings_clear_cache': 'Cache wissen',
    'settings_cache_cleared': 'Cache, Theme & Wishlist gewist',
    'settings_cache_warning':
        'Dit zal alle lokale data, inclusief je verlanglijst en winkelwagen, definitief verwijderen.',
    'settings_about': 'OVER',
    'settings_version': 'Versie',
    'settings_privacy_policy': 'Privacybeleid',
    'settings_terms_of_service': 'Algemene voorwaarden',
  };

  static final Map<String, String> _english = {
    // Navigation
    'nav_home': 'Home',
    'nav_wishlist': 'Wishlist',
    'nav_chat': 'Chat',
    'nav_settings': 'Settings',

    // Discover Screen
    'discover_title': 'Discover Shop',
    'discover_search': 'Search products...',
    'discover_error': 'Error loading',
    'discover_no_products': 'No products found.',

    // Categories
    'category_all': 'All',
    'category_electronics': 'Electronics',
    'category_jewelery': 'Jewelery',
    'category_men\'s clothing': 'Men\'s clothing',
    'category_women\'s clothing': 'Women\'s clothing',

    // Wishlist Screen
    'wishlist_title': 'My Favorites',
    'wishlist_empty': 'Your wishlist is empty',
    'wishlist_empty_subtitle':
        'Save your favorite items here to easily find them later.',
    'wishlist_start_shopping': 'Discover Items',
    'wishlist_remove': 'Remove',
    'wishlist_add_to_cart': 'Add to Cart',
    'wishlist_go_to_cart': 'Go to Cart',
    'wishlist_clear_title': 'Clear Wishlist?',
    'wishlist_clear_message': 'Are you sure you want to remove all items?',
    'wishlist_clear_cancel': 'Cancel',
    'wishlist_clear_confirm': 'Yes, clear all',

    // Cart Page
    'cart_title': 'Shopping Cart',
    'cart_empty': 'Your cart is empty',
    'cart_total': 'Total',
    'cart_checkout': 'Checkout',
    'cart_order_placed': 'Order placed!',

    // Product Detail Screen
    'product_reviews': 'reviews',
    'product_select_color': 'SELECT COLOR',
    'product_size': 'SIZE',
    'product_size_guide': 'Size Guide',
    'product_size_guide_title': 'Size Guide',
    'product_size_guide_subtitle': 'All measurements are in centimeters (cm).',
    'product_size_guide_close': 'Close',
    'product_size_guide_no_table':
        'No specific size table available for this product.',
    'product_size_table_size': 'Size',
    'product_size_table_chest': 'Chest',
    'product_size_table_length': 'Length',
    'product_description': 'Description',
    'product_specs_title': 'SPECS',
    'product_specs_quality': 'High Quality',
    'product_specs_warranty': 'WARRANTY',
    'product_specs_warranty_value': '2 Years',
    'product_add_to_cart': 'Add to Cart',
    'product_added_to_cart': 'Added to bag! 🛍️',
    'product_reviews_title': 'Reviews',
    'product_reviews_view_all': 'View All',

    // Settings Screen
    'settings_title': 'Settings',
    'settings_appearance': 'APPEARANCE',
    'settings_dark_mode': 'Dark Mode',
    'settings_language': 'Language',
    'settings_recent_orders': 'RECENT ORDERS',
    'settings_no_orders': 'No orders yet',
    'settings_order': 'Order',
    'settings_order_details': 'Order Details',
    'settings_total': 'Total',
    'settings_data_storage': 'DATA & STORAGE',
    'settings_used_storage': 'Used Storage',
    'settings_clear_cache': 'Clear Cache',
    'settings_cache_cleared': 'Cache, Theme & Wishlist cleared',
    'settings_cache_warning':
        'This will permanently delete all local data, including your wishlist and shopping cart.',
    'settings_about': 'ABOUT',
    'settings_version': 'Version',
    'settings_privacy_policy': 'Privacy Policy',
    'settings_terms_of_service': 'Terms of Service',
  };
}
