import 'package:flutter/material.dart';
import 'package:yominero/shared/models/product.dart';
import 'core/di/locator.dart';
import 'features/products/domain/product_repository.dart';
import 'core/theme/colors.dart';
import 'core/routing/app_router.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductRepository _repo;
  late List<Product> _allProducts;
  bool _isLoadingRemote = false;
  String? _remoteError;

  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  final List<String> _categories = const [
    'Todos',
    'Seguridad',
    'Herramientas',
    'Equipos',
    'Accesorios',
  ];

  final List<Color> _productColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.success,
    AppColors.info,
    AppColors.warning,
    AppColors.primaryContainer,
    AppColors.secondaryContainer,
    AppColors.textSecondary,
  ];

  @override
  void initState() {
    super.initState();
    _repo = sl<ProductRepository>();
    _allProducts = [];

    _isLoadingRemote = true;
    () async {
      try {
        final list = await _repo.getAll().timeout(const Duration(seconds: 8), onTimeout: () => <Product>[]);
        if (!mounted) return;
        setState(() {
          _allProducts = list;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _remoteError = e.toString();
        });
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoadingRemote = false;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allProducts.where((p) {
      final search = _searchQuery.toLowerCase();
      final matchesSearch = p.name.toLowerCase().contains(search) ||
          p.description.toLowerCase().contains(search);
      // Category filtering placeholder removed (no category on Product yet) -> only search filter applied
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.secondary.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Marketplace',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Productos para minería',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar productos...',
                        hintStyle:
                            const TextStyle(color: AppColors.textSecondary),
                        prefixIcon:
                            const Icon(Icons.search, color: AppColors.primary),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.textSecondary),
                                onPressed: () =>
                                    setState(() => _searchQuery = ''),
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: EdgeInsets.only(
                              right: index == _categories.length - 1 ? 0 : 12),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (_) =>
                                setState(() => _selectedCategory = category),
                            backgroundColor: AppColors.surface,
                            selectedColor: AppColors.primaryContainer,
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.outline,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoadingRemote)
                    const LinearProgressIndicator(minHeight: 3),
                  if (_remoteError != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.2)),
                      ),
                      child: const Text(
                        'Error al cargar productos remotos',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  Text(
                    '${filtered.length} productos encontrados',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filtered[index];
                  final color = _productColors[index % _productColors.length];
                  return _ProductCard(
                    product: product,
                    color: color,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.productDetail,
                      arguments: product,
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final Color color;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getProductIcon(product.name),
                          size: 40,
                          color: color,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.textPrimary.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          '\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        const Text(
                          '4.5',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Disponible',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getProductIcon(String productName) {
    final name = productName.toLowerCase();
    if (name.contains('casco')) return Icons.construction;
    if (name.contains('linterna')) return Icons.flashlight_on;
    if (name.contains('guantes')) return Icons.back_hand;
    if (name.contains('botas')) return Icons.work;
    if (name.contains('chaleco')) {
      return Icons.warning; // closest available icon
    }
    if (name.contains('detector')) return Icons.sensors;
    if (name.contains('cuerda')) return Icons.link;
    if (name.contains('martillo')) return Icons.build;
    return Icons.inventory;
  }
}
