import 'package:yominero/shared/models/service.dart';

abstract class ServiceRepository {
  List<Service> getAll();
  Service? getById(String id);
}
