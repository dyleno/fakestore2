import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/order.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  static const String _boxName = 'ordersBox';
  final ValueNotifier<List<Order>> ordersNotifier =
      ValueNotifier<List<Order>>([]);

  Future<void> init() async {
    final box = await Hive.openBox<Order>(_boxName);
    ordersNotifier.value = box.values.toList().reversed.toList();
  }

  Future<void> addOrder(Order order) async {
    final box = Hive.box<Order>(_boxName);
    await box.add(order);
    ordersNotifier.value = box.values.toList().reversed.toList();
  }

  Future<void> clearOrders() async {
    final box = Hive.box<Order>(_boxName);
    await box.clear();
    ordersNotifier.value = [];
  }
}
