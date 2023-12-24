import 'package:flutter/material.dart';

class HoldItem {
  final String orderId;
  final List<String> productIds;
  final double totalAmount;
  final DateTime orderDateTime;

  HoldItem({
    required this.orderId,
    required this.productIds,
    required this.totalAmount,
    required this.orderDateTime,
  });
}

class HoldProvider with ChangeNotifier {
  List<HoldItem> _heldOrders = [];

  List<HoldItem> get heldOrders => _heldOrders;

  int get orderCount => _heldOrders.length;

  void holdOrder({
    required String orderId,
    required List<String> productIds,
    required double totalAmount,
  }) {
    // Create a new HoldItem and add it to the list of held orders
    HoldItem newHoldItem = HoldItem(
      orderId: orderId,
      productIds: productIds,
      totalAmount: totalAmount,
      orderDateTime: DateTime.now(),
    );
    _heldOrders.add(newHoldItem);

    // Notify listeners that the list of held orders has been updated
    notifyListeners();
  }

  void removeHoldOrder(String orderId) {
    _heldOrders.removeWhere((item) => item.orderId == orderId);

    // Notify listeners that the list of held orders has been updated
    notifyListeners();
  }

  void clearHoldOrders() {
    _heldOrders.clear();

    // Notify listeners that the list of held orders has been updated
    notifyListeners();
  }
}
