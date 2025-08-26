import 'package:flutter/material.dart';
import 'package:yominero/shared/models/post.dart';
import 'package:yominero/shared/models/service.dart';
import 'core/theme/colors.dart';
import 'core/di/locator.dart';
import 'core/auth/auth_service.dart';
import 'core/matching/match_engine.dart';
import 'features/services/domain/service_repository.dart';
import 'features/posts/domain/post_repository.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with SingleTickerProviderStateMixin {
  late final ServiceRepository _repo;
  late final PostRepository _postRepo;
  late List<Service> _services;
  bool _servicesLoading = true;
  late TabController _tabController;
  List<MatchResult> _suggestedRequests = [];
  List<MatchResult> _opportunities = [];

  @override
  void initState() {
    super.initState();
    _repo = sl<ServiceRepository>();
    _postRepo = sl<PostRepository>();
    _services = [];
    _tabController = TabController(length: 3, vsync: this);
    _computeMatches();
  _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _servicesLoading = true);
    try {
      final res = await _repo.getAll().timeout(const Duration(seconds: 8), onTimeout: () => <Service>[]);
      if (!mounted) return;
      setState(() => _services = res);
    } catch (e) {
      if (!mounted) return;
      // keep empty list and stop loading
    } finally {
      if (!mounted) return;
      setState(() => _servicesLoading = false);
    }
  }

  Future<void> _computeMatches() async {
    final user = AuthService.instance.currentUser;
  final posts = await _postRepo.getAll().timeout(const Duration(seconds: 8), onTimeout: () => <Post>[]);
    if (user != null) {
      setState(() {
        _suggestedRequests = MatchEngine.requestsForUser(user, posts);
        _opportunities = MatchEngine.opportunitiesForUser(user, posts);
      });
    } else {
      setState(() {
        _suggestedRequests = [];
        _opportunities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Servicios', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Mis Servicios'),
            Tab(text: 'Solicitudes para mí'),
            Tab(text: 'Oportunidades'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              setState(() => _computeMatches());
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyServices(),
          _buildMatchList(_suggestedRequests, emptyLabel: 'Sin sugerencias'),
          _buildMatchList(_opportunities, emptyLabel: 'Sin oportunidades'),
        ],
      ),
    );
  }

  Widget _buildMyServices() {
    if (_servicesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_services.isEmpty) {
      return Center(
        child: Text('Sin servicios todavía',
            style: Theme.of(context).textTheme.bodyMedium),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getServiceColor(service.name).withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getServiceIcon(service.name),
                  color: _getServiceColor(service.name),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(service.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[700])),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('\$${service.rate.toStringAsFixed(0)}/h',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMatchList(List<MatchResult> list, {required String emptyLabel}) {
    if (list.isEmpty) {
      return Center(
        child: Text(emptyLabel, style: Theme.of(context).textTheme.bodyMedium),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final mr = list[index];
        final p = mr.post;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(p.type.name,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                  Text('${mr.score} pts',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 8),
              Text(p.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(p.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700])),
              if (p.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: -4,
                  children: p.tags
                      .take(5)
                      .map((t) => Chip(
                            label:
                                Text(t, style: const TextStyle(fontSize: 11)),
                            backgroundColor: AppColors.secondaryContainer,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ))
                      .toList(),
                )
              ]
            ],
          ),
        );
      },
    );
  }

  IconData _getServiceIcon(String serviceName) {
    if (serviceName.toLowerCase().contains('topografía')) {
      return Icons.map_outlined;
    } else if (serviceName.toLowerCase().contains('mantenimiento')) {
      return Icons.build_outlined;
    } else if (serviceName.toLowerCase().contains('legal')) {
      return Icons.gavel_outlined;
    }
    return Icons.miscellaneous_services_outlined;
  }

  Color _getServiceColor(String serviceName) {
    final lower = serviceName.toLowerCase();
    if (lower.contains('topografía') || lower.contains('mapeo')) {
      return AppColors.info;
    } else if (lower.contains('mantenimiento')) {
      return AppColors.success;
    } else if (lower.contains('legal')) {
      return AppColors.textSecondary;
    }
    return AppColors.primary;
  }
}
