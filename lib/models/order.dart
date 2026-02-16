import 'package:hive/hive.dart';
import 'cart_item.dart';

part 'order.g.dart';

@HiveType(typeId: 2)
class Order extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<CartItem> items;

  @HiveField(2)
  final double totalAmount;

  @HiveField(3)
  final DateTime date;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
  });
}
