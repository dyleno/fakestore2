import 'language_provider.dart';

class Translations {
  static Map<String, String> get(AppLanguage language) {
    return language == AppLanguage.dutch ? _dutch : _english;
  }

  // Dutch translations
  static const Map<String, String> _dutch = {
    // Navigation
    'nav_home': 'Home',
    'nav_wishlist': 'Verlanglijst',
    'nav_settings': 'Instellingen',

    // Settings Screen
    'settings_title': 'Instellingen',
    'settings_appearance': 'UITERLIJK',
    'settings_dark_mode': 'Donkere Modus',
    'settings_language': 'Taal',
    'settings_recent_orders': 'RECENTE AANKOPEN',
    'settings_no_orders': 'Nog geen bestellingen',
    'settings_order': 'Bestelling',
    'settings_order_details': 'Bestelling Details',
    'settings_total': 'Totaal',
    'settings_data_storage': 'DATA & OPSLAG',
    'settings_used_storage': 'Gebruikt Opslag',
    'settings_clear_cache': 'Cache Wissen',
    'settings_cache_warning':
        'Het wissen van de cache kan ervoor zorgen dat de lichte modus wordt hersteld en de winkelwagen/verlanglijst wordt geleegd.',
    'settings_cache_cleared': 'Cache, Thema & Verlanglijst gewist',
    'settings_about': 'OVER',
    'settings_version': 'Versie',
    'settings_privacy_policy': 'Privacybeleid',
    'settings_terms_of_service': 'Servicevoorwaarden',

    // Discover Screen
    'discover_title': 'Ontdekken',
    'discover_search': 'Zoek producten...',
    'discover_all': 'Alle',
    'discover_mens': 'Heren',
    'discover_womens': 'Dames',
    'discover_jewelry': 'Sieraden',
    'discover_electronics': 'Elektronica',
    'discover_loading': 'Producten laden...',
    'discover_error': 'Fout bij laden van producten',
    'discover_no_products': 'Geen producten gevonden',

    // Category mappings (API to Dutch)
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

    // Cart Screen
    'cart_title': 'Winkelwagen',
    'cart_empty': 'Je winkelwagen is leeg',
    'cart_empty_subtitle': 'Voeg producten toe om te beginnen met winkelen',
    'cart_subtotal': 'Subtotaal',
    'cart_shipping': 'Verzending',
    'cart_free': 'GRATIS',
    'cart_total': 'Totaal',
    'cart_checkout': 'Afrekenen',
    'cart_item_removed': 'Product verwijderd uit winkelwagen',
    'cart_undo': 'Ongedaan maken',
    'cart_order_placed': 'Bestelling geplaatst!',
    'cart_order_success': 'Je bestelling is succesvol geplaatst',

    // Product Detail Screen
    'product_description': 'Beschrijving',
    'product_rating': 'Beoordeling',
    'product_reviews': 'beoordelingen',
    'product_add_to_cart': 'In mijn mandje',
    'product_added_to_cart': 'Toegevoegd aan mandjes! 🛍️',
    'product_ask_ai': 'Vraag AI over dit product',
    'product_specifications': 'Specificaties',
    'product_category': 'Categorie',
    'product_availability': 'Beschikbaarheid',
    'product_in_stock': 'Op voorraad',
    'product_select_color': 'SELECTEER KLEUR',
    'product_size': 'MAAT',
    'product_size_guide': 'Size Guide',
    'product_size_guide_title': 'Size Guide',
    'product_size_guide_subtitle': 'Alle afmetingen zijn in centimeters (cm).',
    'product_size_guide_close': 'Sluiten',
    'product_size_guide_no_table':
        'Voor dit product is geen specifieke maattabel beschikbaar. Het betreft een \'Universal\' maat.',
    'product_size_table_size': 'Maat',
    'product_size_table_chest': 'Borst',
    'product_size_table_length': 'Lengte',
    'product_specs_quality': 'Hoogwaardig',
    'product_specs_warranty': 'GARANTIE',
    'product_specs_warranty_value': '2 Jaar',
    'product_specs_title': 'SPECS',
    'product_reviews_title': 'Reviews',
    'product_reviews_view_all': 'Bekijk alles',

    // Chat Screen
    'chat_title': 'Product Assistent',
    'chat_placeholder': 'Stel een vraag over dit product...',
    'chat_thinking': 'Aan het nadenken...',

    // Onboarding
    'onboarding_skip': 'Overslaan',
    'onboarding_next': 'Volgende',
    'onboarding_get_started': 'Aan de slag',

    // Common
    'common_loading': 'Laden...',
    'common_error': 'Fout',
    'common_retry': 'Opnieuw proberen',
    'common_cancel': 'Annuleren',
    'common_ok': 'OK',
    'common_save': 'Opslaan',
    'common_delete': 'Verwijderen',
    'common_edit': 'Bewerken',
    'common_close': 'Sluiten',
  };

  // English translations
  static const Map<String, String> _english = {
    // Navigation
    'nav_home': 'Home',
    'nav_wishlist': 'Wishlist',
    'nav_settings': 'Settings',

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
    'settings_cache_warning':
        'Clearing the cache can cause light mode to be restored and the shopping cart/wishlist to be emptied.',
    'settings_cache_cleared': 'Cache, Theme & Wishlist cleared',
    'settings_about': 'ABOUT',
    'settings_version': 'Version',
    'settings_privacy_policy': 'Privacy Policy',
    'settings_terms_of_service': 'Terms of Service',

    // Discover Screen
    'discover_title': 'Discover',
    'discover_search': 'Search products...',
    'discover_all': 'All',
    'discover_mens': 'Men\'s',
    'discover_womens': 'Women\'s',
    'discover_jewelry': 'Jewelry',
    'discover_electronics': 'Electronics',
    'discover_loading': 'Loading products...',
    'discover_error': 'Error loading products',
    'discover_no_products': 'No products found',

    // Category mappings (API to English)
    'category_all': 'All',
    'category_electronics': 'Electronics',
    'category_jewelery': 'Jewelry',
    'category_men\'s clothing': 'Men\'s Clothing',
    'category_women\'s clothing': 'Women\'s Clothing',

    // Wishlist Screen
    'wishlist_title': 'My Favorites',
    'wishlist_empty': 'Your wishlist is still empty',
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

    // Cart Screen
    'cart_title': 'Shopping Cart',
    'cart_empty': 'Your cart is empty',
    'cart_empty_subtitle': 'Add products to start shopping',
    'cart_subtotal': 'Subtotal',
    'cart_shipping': 'Shipping',
    'cart_free': 'FREE',
    'cart_total': 'Total',
    'cart_checkout': 'Checkout',
    'cart_item_removed': 'Item removed from cart',
    'cart_undo': 'Undo',
    'cart_order_placed': 'Order Placed!',
    'cart_order_success': 'Your order has been placed successfully',

    // Product Detail Screen
    'product_description': 'Description',
    'product_rating': 'Rating',
    'product_reviews': 'reviews',
    'product_add_to_cart': 'Add to Bag',
    'product_added_to_cart': 'Added to bag! 🛍️',
    'product_ask_ai': 'Ask AI about this product',
    'product_specifications': 'Specifications',
    'product_category': 'Category',
    'product_availability': 'Availability',
    'product_in_stock': 'In Stock',
    'product_select_color': 'SELECT COLOR',
    'product_size': 'SIZE',
    'product_size_guide': 'Size Guide',
    'product_size_guide_title': 'Size Guide',
    'product_size_guide_subtitle': 'All measurements are in centimeters (cm).',
    'product_size_guide_close': 'Close',
    'product_size_guide_no_table':
        'No specific size chart is available for this product. It is a \'Universal\' size.',
    'product_size_table_size': 'Size',
    'product_size_table_chest': 'Chest',
    'product_size_table_length': 'Length',
    'product_specs_quality': 'High Quality',
    'product_specs_warranty': 'WARRANTY',
    'product_specs_warranty_value': '2 Years',
    'product_specs_title': 'SPECS',
    'product_reviews_title': 'Reviews',
    'product_reviews_view_all': 'View All',

    // Chat Screen
    'chat_title': 'Product Assistant',
    'chat_placeholder': 'Ask a question about this product...',
    'chat_thinking': 'Thinking...',

    // Onboarding
    'onboarding_skip': 'Skip',
    'onboarding_next': 'Next',
    'onboarding_get_started': 'Get Started',

    // Common
    'common_loading': 'Loading...',
    'common_error': 'Error',
    'common_retry': 'Retry',
    'common_cancel': 'Cancel',
    'common_ok': 'OK',
    'common_save': 'Save',
    'common_delete': 'Delete',
    'common_edit': 'Edit',
    'common_close': 'Close',
  };
}
