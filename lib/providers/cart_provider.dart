import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

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
    // Check if the product is already in the cart
    int existingIndex = _cartItems.indexWhere((item) => item.productId == productId);

    if (existingIndex != -1) {
      // If the product is already in the cart, update the quantity
      _cartItems[existingIndex] = CartItem(
        productId: productId,
        productName: productName,
        price: price,
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      // If the product is not in the cart, add it
      _cartItems.add(CartItem(
        productId: productId,
        productName: productName,
        price: price,
        quantity: quantity,
      ));
    }

    // Notify listeners that the cart has been updated
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);

    // Notify listeners that the cart has been updated
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();

    // Notify listeners that the cart has been updated
    notifyListeners();
  }
}
