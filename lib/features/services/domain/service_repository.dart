import 'package:yominero/shared/models/service.dart';

abstract class ServiceRepository {
  Future<List<Service>> getAll();
  Service? getById(String id);
}
