import 'package:flutter/material.dart';
import 'models/service.dart';

/// Displays detailed information about a service provider and allows
/// users to request a quote. In a full implementation, the quote
/// request would trigger navigation to a form or send a message to
/// the provider.
class ServiceDetailPage extends StatelessWidget {
  final Service service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Tarifa: \$${service.rate.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Placeholder for request quote logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Solicitud de cotización enviada')),
                );
              },
              child: const Text('Solicitar cotización'),
            ),
          ],
        ),
      ),
    );
  }
}