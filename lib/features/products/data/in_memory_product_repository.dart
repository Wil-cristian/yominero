import 'package:yominero/shared/models/product.dart';
import '../../products/domain/product_repository.dart';

class InMemoryProductRepository implements ProductRepository {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Casco de seguridad',
      description: 'Casco resistente para protección en minas',
      price: 50.0,
    ),
    Product(
      id: '2',
      name: 'Linterna LED',
      description: 'Linterna recargable de alta potencia',
      price: 30.0,
    ),
    Product(
      id: '3',
      name: 'Guantes de trabajo',
      description: 'Guantes de cuero para manipulación y carga',
      price: 20.0,
    ),
    Product(
      id: '4',
      name: 'Botas de seguridad',
      description: 'Botas con puntera de acero',
      price: 75.0,
    ),
    Product(
      id: '5',
      name: 'Chaleco reflectivo',
      description: 'Chaleco de alta visibilidad',
      price: 25.0,
    ),
    Product(
      id: '6',
      name: 'Detector de gases',
      description: 'Detector portátil multigas',
      price: 350.0,
    ),
    Product(
      id: '7',
      name: 'Cuerda de seguridad',
      description: 'Cuerda dinámica 50m',
      price: 120.0,
    ),
    Product(
      id: '8',
      name: 'Martillo neumático',
      description: 'Herramienta de perforación',
      price: 890.0,
    ),
  ];

  @override
  @override
  Future<List<Product>> getAll() async => List.unmodifiable(_products);

  @override
  Future<Product?> getById(String id) async =>
      _products.firstWhere((p) => p.id == id,
          orElse: () => Product(
              id: '0',
              name: 'Desconocido',
              description: 'No encontrado',
              price: 0));
}
