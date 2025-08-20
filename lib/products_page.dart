import 'package:flutter/material.dart';
import 'models/product.dart';
import 'product_detail_page.dart';

/// Displays a list of products and allows users to add or remove
/// products from a simple cart. Tapping on a product navigates to
/// the [ProductDetailPage].
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Casco de seguridad',
      description: 'Casco resistente para protección en minas',
      price: 50.0,
    ),
    Product(
      id: '2',
      name: 'Linterna LED',
      description: 'Linterna recargable de alta potencia',
      price: 30.0,
    ),
    Product(
      id: '3',
      name: 'Guantes de trabajo',
      description: 'Guantes de cuero para manipulación y carga',
      price: 20.0,
    ),
  ];

  final Set<int> _cart = {};

  void _toggleCart(int index) {
    setState(() {
      if (_cart.contains(index)) {
        _cart.remove(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminado del carrito')),
        );
      } else {
        _cart.add(index);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agregado al carrito')),
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
          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.description),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(
                inCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
              ),
              onPressed: () => _toggleCart(index),
            ),
          );
        },
      ),
    );
  }
}