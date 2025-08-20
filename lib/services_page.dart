import 'package:flutter/material.dart';
import 'models/service.dart';
import 'service_detail_page.dart';

/// Displays a list of available services and allows users to view
/// details about each service. In this simplified version the
/// services are hard-coded but in a complete application they
/// would be fetched from a database or API.
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Service> services = [
      Service(
        id: 's1',
        name: 'Topografía y mapeo',
        description:
            'Servicio de topografía y mapeo para estudios y planificación.',
        rate: 120.0,
      ),
      Service(
        id: 's2',
        name: 'Mantenimiento de maquinaria',
        description:
            'Revisión y reparación de equipos pesados de minería.',
        rate: 200.0,
      ),
      Service(
        id: 's3',
        name: 'Asesoría legal minera',
        description: 'Consultoría en normas y licencias de minería.',
        rate: 150.0,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ListTile(
            title: Text(service.name),
            subtitle: Text(service.description),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ServiceDetailPage(service: service),
                ),
              );
            },
          );
        },
      ),
    );
  }
}