import 'package:flutter/material.dart';
import 'package:yominero/shared/models/category.dart';



/// Displays a list of categories for products and services. Each
/// category includes an identifier, a name, and a description.
/// Tapping on a category could filter products/services or
/// navigate to a dedicated page in a complete application.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = [
      Category(
        id: 'c1',
        name: 'Equipos de protección',
        description: 'Cascos, guantes, gafas y más',
      ),
      Category(
        id: 'c2',
        name: 'Iluminación',
        description: 'Linternas, lámparas, baterías',
      ),
      Category(
        id: 'c3',
        name: 'Servicios técnicos',
        description: 'Topografía, mantenimiento, asesorías',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.name),
            subtitle: Text(category.description),
            onTap: () {
              // Placeholder for category navigation or filtering.
            },
          );
        },
      ),
    );
  }
}
