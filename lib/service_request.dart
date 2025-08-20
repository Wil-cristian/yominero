/// A model for representing a service request (RFP) posted by the
/// user or cooperative. It records the type of service, a brief
/// description, and the current status of the request.
class ServiceRequest {
  final String id;
  final String serviceName;
  final String description;
  final String status;

  ServiceRequest({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.status,
  });
}
