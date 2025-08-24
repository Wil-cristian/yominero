# YoMinero

Aplicación Flutter modularizada con capas simples (features/domain/data) y paleta semántica.

## Arquitectura
- core/: tema, routing, auth y localizador sencillo.
- features/: cada dominio (posts, products, services) con data + domain.
- shared/models: modelos compartidos exportados vía barrel.

## Repositorios
Se usan implementaciones en memoria para desarrollo rápido. Sustituir por fuentes remotas o SQLite conforme crezca.

## Colores
`AppColors` define tokens semánticos (primary, surface, success, info, etc.). Usa esos valores en lugar de hex directos.

## Tests
Ejemplo: `test/post_repository_test.dart` valida la lógica de likes únicos.

## Próximos pasos sugeridos
1. Migrar SDK a >=3.3 y habilitar records/patterns.
2. Integrar gestor de estado (Provider, Riverpod) en lugar de locator manual.
3. Persistencia real para likes y datos.
4. Tests widget para navegación.
# yominero

A new Flutter project.
