import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Topograf\u00eda y mapeo',
      'description': 'Servicio de topograf\u00eda para estudios y planificaci\u00f3n.',
      'requested': false,
    },
    {
      'title': 'Mantenimiento de maquinaria',
      'description': 'Revisi\u00f3n y reparaci\u00f3n de equipos pesados de miner\u00eda.',
      'requested': false,
    },
    {
      'title': 'Asesor\u00eda legal minera',
      'description': 'Consultor\u00eda en normas y licencias de miner\u00eda.',
      'requested': false,
    },
  ];

  void _toggleRequest(int index) {
    setState(() {
      _services[index]['requested'] = !_services[index]['requested'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_services[index]['requested']
            ? 'Solicitud enviada'
            : 'Solicitud cancelada'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(service['description']),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => _toggleRequest(index),
                      child: Text(service['requested'] ? 'Cancelar' : 'Solicitar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
