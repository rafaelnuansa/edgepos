// cart_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edgepos/providers/cart_provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key}) : super(key: key);

  @override
  CartWidgetState createState() => CartWidgetState();
}

class CartWidgetState extends State<CartWidget> {
  late CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    // Use Provider to get the CartProvider instance
    cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the cart items
            ...cartProvider.cartItems.map((cartItem) => _buildCartItem(context, cartItem)),
             const Divider(), // Divider untuk memisahkan item dan total
            const SizedBox(height: 16.0),
            
            Text(
              'Total : BND ${cartProvider.totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Hold Order List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pause),
            label: 'Hold',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Cancel',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation bar taps
          // You can add your logic here
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem) {
    return ListTile(
      title: Text(cartItem.productName),
      subtitle: Text('Price: BND ${cartItem.price.toStringAsFixed(2)} | Quantity: ${cartItem.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditQuantityBottomSheet(context, cartItem);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Remove the item from the cart when the delete button is pressed
              Provider.of<CartProvider>(context, listen: false).removeFromCart(cartItem.productId);
            },
          ),
        ],
      ),
    );
  }

 void _showEditQuantityBottomSheet(BuildContext context, CartItem cartItem) {
  int localQuantity = cartItem.quantity; // Initial quantity value

  TextEditingController quantityController = TextEditingController(text: localQuantity.toString());

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Edit Quantity'),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (localQuantity > 1) {
                            localQuantity--;
                            quantityController.text = localQuantity.toString();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 40.0,
                      child: TextField(
                        controller: quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {
                            localQuantity = int.parse(text);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          localQuantity++;
                          quantityController.text = localQuantity.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Update the quantity in the cart provider
                    Provider.of<CartProvider>(context, listen: false).updateQuantity(cartItem.productId, localQuantity);

                    // Close the bottom sheet
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

 }
