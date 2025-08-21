import 'package:flutter/material.dart';
import 'package:yominero/shared/models/order.dart';
import 'package:yominero/shared/models/product.dart';

//import 'package:yominero/shared/models/order.dart/order.dart';
//import 'models/product.dart';

/// A simple page that shows a list of orders. Each order contains
/// multiple products, a total amount, and a status. Tapping on
/// an order does nothing in this demo but could navigate to a
/// detailed view of the order.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample orders for demonstration purposes. In a real app these
    // would be loaded from persistent storage or fetched from a server.
    final List<Order> orders = [
      Order(
        id: 'o1',
        items: [
          Product(
            id: '1',
            name: 'Casco de seguridad',
            description: '',
            price: 50.0,
          ),
          Product(
            id: '2',
            name: 'Linterna LED',
            description: '',
            price: 30.0,
          ),
        ],
        total: 80.0,
        status: 'Enviado',
      ),
      Order(
        id: 'o2',
        items: [
          Product(
            id: '3',
            name: 'Guantes de trabajo',
            description: '',
            price: 20.0,
          ),
        ],
        total: 20.0,
        status: 'Procesando',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text('Pedido ${order.id}'),
            subtitle: Text(
              'Total: \$${order.total.toStringAsFixed(2)} - Estado: ${order.status}',
            ),
            onTap: () {
              // In a complete app you could navigate to a detailed order page here.
            },
          );
        },
      ),
    );
  }
}
