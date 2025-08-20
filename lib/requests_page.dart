import 'package:flutter/material.dart';
import 'models/service_request.dart';

/// Shows a list of service requests (RFPs) with their current
/// status. This page is stateless because the data is static for
/// this example. In a real implementation the list would be
/// fetched from the user's account or a backend service.
class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ServiceRequest> requests = [
      ServiceRequest(
        id: 'r1',
        serviceName: 'Topografía',
        description: 'Estudio de topografía para nueva mina',
        status: 'Pendiente',
      ),
      ServiceRequest(
        id: 'r2',
        serviceName: 'Mantenimiento de maquinaria',
        description: 'Revisión y mantenimiento de excavadora',
        status: 'Aceptado',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes de servicio')),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return ListTile(
            title: Text(req.serviceName),
            subtitle: Text('Estado: ${req.status}'),
            onTap: () {
              // In a full app you might open a chat or detail view of the request.
            },
          );
        },
      ),
    );
  }
}