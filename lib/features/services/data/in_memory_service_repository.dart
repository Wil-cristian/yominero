import 'package:yominero/shared/models/service.dart';
import '../../services/domain/service_repository.dart';

class InMemoryServiceRepository implements ServiceRepository {
  final List<Service> _services = [
    Service(
        id: 's1',
        name: 'Topografía y mapeo',
        description:
            'Servicio de topografía y mapeo para estudios y planificación.',
        rate: 120.0),
    Service(
        id: 's2',
        name: 'Mantenimiento de maquinaria',
        description: 'Revisión y reparación de equipos pesados de minería.',
        rate: 200.0),
    Service(
        id: 's3',
        name: 'Asesoría legal minera',
        description: 'Consultoría en normas y licencias de minería.',
        rate: 150.0),
  ];

    @override
    Future<List<Service>> getAll() async => List.unmodifiable(_services);

  @override
  Service? getById(String id) => _services.firstWhere((s) => s.id == id,
      orElse: () => Service(
          id: '0', name: 'Desconocido', description: 'No encontrado', rate: 0));
}
