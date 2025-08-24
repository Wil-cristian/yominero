import 'package:flutter/material.dart';
import 'package:yominero/shared/models/product.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Product> _allProducts = [
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

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final List<Product> filtered = _allProducts.where((p) {
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar productos',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final product = filtered[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(product.name),
                      subtitle: Text(product.description),
                      trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
