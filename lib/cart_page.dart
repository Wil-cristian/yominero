import 'package:flutter/material.dart';
import 'package:yominero/shared/models/product.dart';

/// A simple cart page that displays items added to the cart and
/// allows users to remove them. The total price of all items is
/// shown at the bottom of the screen.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // In a real application this list would come from a shared state
  // provider or backend. For this demo it's maintained locally.
  final List<Product> _items = [];

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto eliminado del carrito')),
    );
  }

  double _calculateTotal() {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: _items.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final product = _items[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Total: \$${_calculateTotal().toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}
