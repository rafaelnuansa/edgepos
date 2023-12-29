// cart_provider.dart

import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String productName;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addToCart({
    required String productId,
    required String productName,
    required double price,
    int quantity = 1,
  }) {
    int existingIndex = _cartItems.indexWhere((item) => item.productId == productId);

    if (existingIndex != -1) {
      _cartItems[existingIndex] = CartItem(
        productId: productId,
        productName: productName,
        price: price,
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(
        productId: productId,
        productName: productName,
        price: price,
        quantity: quantity,
      ));
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    int existingIndex = _cartItems.indexWhere((item) => item.productId == productId);

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
