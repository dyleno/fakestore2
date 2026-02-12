import 'package:hive/hive.dart';
import 'product.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  final String? selectedSize;

  @HiveField(3)
  final String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });
}
