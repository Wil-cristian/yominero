import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Map<String, String>> _products = [
    {
      'name': 'Casco de seguridad',
      'description': 'Casco resistente para protección en minas',
    },
    {
      'name': 'Linterna LED',
      'description': 'Linterna recargable de alta potencia',
    },
    {
      'name': 'Guantes de trabajo',
      'description': 'Guantes de cuero para manipulación y carga',
    },
  ];

  final Set<int> _cart = {};

  void _toggleCart(int index) {
    final product = _products[index];
    setState(() {
      if (_cart.contains(index)) {
        _cart.remove(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product['name']} eliminado del carrito')),
        );
      } else {
        _cart.add(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product['name']} agregado al carrito')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final inCart = _cart.contains(index);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(product['name']!),
              subtitle: Text(product['description']!),
              trailing: IconButton(
                icon: Icon(
                  inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                ),
                onPressed: () => _toggleCart(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
