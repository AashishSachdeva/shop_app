import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime time;
  OrderItem({
    required this.amount,
    required this.cartItems,
    required this.id,
    required this.time,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        cartItems: cartItems,
        id: DateTime.now().toString(),
        time: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
