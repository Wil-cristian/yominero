# YoMinero - Flutter Web Application

## Overview
YoMinero es una aplicación Flutter modularizada con una interfaz de comunidad, grupos, productos y servicios. La aplicación utiliza una arquitectura limpia con separación de capas (features/domain/data) y gestión de estado con get_it.

## Project Status
- **Last Updated:** 2025-10-20
- **Current State:** Aplicación Flutter web funcionando correctamente en Replit
- **Deployment:** Configurado para autoscale deployment

## Technical Stack
- **Framework:** Flutter 3.35.6
- **Language:** Dart 3.9.2
- **Target Platform:** Web
- **State Management:** get_it (dependency injection)
- **Data Storage:** In-memory repositories (no external database)

## Project Structure
```
lib/
├── core/                           # Core functionality
│   ├── auth/                       # Authentication services
│   ├── database/                   # Database helpers
│   ├── di/                         # Dependency injection (locator)
│   ├── groups/                     # Group management
│   ├── matching/                   # Match engine & suggestions
│   ├── posts/                      # Post management
│   ├── products/                   # Product management
│   ├── routing/                    # App router
│   └── theme/                      # App theme & colors
│       ├── animations.dart         # Premium animation system (NEW)
│       ├── glass_card.dart         # Glassmorphism components (NEW)
│       ├── theme.dart              # Enhanced theme with shadows/gradients
│       └── colors.dart             # Semantic color tokens
├── features/                       # Feature modules
│   ├── posts/                      # Posts feature
│   ├── products/                   # Products feature
│   └── services/                   # Services feature
├── models/                         # Data models
├── shared/                         # Shared components
└── [page files]                    # UI pages (community, groups, products, etc.)
```

## Features
1. **Comunidad (Community):** Feed de publicaciones con sistema de likes y comentarios
2. **Grupos (Groups):** Gestión de grupos con sistema de sugerencias
3. **Productos (Products):** Catálogo de productos
4. **Servicios (Services):** Catálogo de servicios
5. **Perfil (Profile):** Perfil de usuario

## Replit Configuration

### Flutter Setup
Flutter SDK está instalado manualmente en `$HOME/flutter` ya que no está disponible como módulo Replit.

### Workflow
- **Development:** Sirve el build de producción desde `build/web` usando Python HTTP server
- **Port:** 5000
- **Host:** 0.0.0.0

### Deployment
- **Target:** autoscale
- **Build:** `flutter build web --release`
- **Run:** Python HTTP server serving `build/web` on port 5000

## Development Workflow

### Building the app
```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter build web --release
```

### Running locally
El workflow está configurado para servir automáticamente el build de producción.

### Hot Reload
Para desarrollo con hot reload:
```bash
export PATH="$HOME/flutter/bin:$PATH"
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 5000
```

## Architecture Notes
- **Repository Pattern:** Utiliza in-memory repositories para desarrollo rápido
- **Semantic Colors:** Define tokens de color semánticos en `AppColors` (primary, surface, success, info, etc.)
- **Modular Structure:** Cada dominio (posts, products, services) tiene su propia capa de data y domain
- **Dependency Injection:** Utiliza get_it para gestión de dependencias
- **Animation System:** Sistema modular de animaciones premium con widgets reutilizables (FadeInSlide, ScaleFadeIn, SlideIn)
- **Premium UI Components:** PremiumCard y GlassCard con gradientes sutiles, sombras profesionales y efectos glassmorphism

## Recent Enhancements (2025-10-20)
### Visual & Animation Improvements
1. **Sistema de Animaciones Premium:**
   - Custom curves (premiumEntry, smoothExit) para transiciones fluidas
   - Widgets reutilizables: FadeInSlide, ScaleFadeIn, SlideIn con delays configurables
   - Duración estandarizada (fast, normal, slow, pageTransition)
   
2. **Componentes Premium:**
   - PremiumCard: Tarjetas con gradientes sutiles, sombras múltiples y efecto hover
   - GlassCard: Efecto glassmorphism con blur y transparencia
   
3. **Mejoras de Tema:**
   - Sombras profesionales con múltiples capas
   - Gradientes sutiles en AppBar y cards
   - Elevación mejorada en bottom navigation bar
   
4. **Animaciones de Página:**
   - Transiciones suaves entre páginas con AnimatedSwitcher
   - Entrada escalonada de tarjetas en CommunityPage
   - Animaciones de scale/fade en tarjetas de sugerencias

## User Preferences
- El usuario prefiere una estética premium y profesional
- Valora las animaciones fluidas y efectos visuales modernos
- Busca una experiencia de usuario pulida y de alta calidad

## Next Steps Suggested
1. ✅ ~~Mejorar la estética visual con animaciones profesionales~~ (COMPLETADO)
2. ✅ ~~Implementar transiciones suaves entre páginas~~ (COMPLETADO)
3. ✅ ~~Agregar efectos visuales modernos~~ (COMPLETADO)
4. Aplicar animaciones a otras páginas (Grupos, Productos, Servicios, Perfil)
5. Considerar actualización de SDK a >=3.3 para habilitar records/patterns
6. Integrar gestor de estado más robusto (Provider, Riverpod)
7. Implementar persistencia real para likes y datos
8. Agregar micro-interacciones (ripple effects, loading states, pull-to-refresh)

## Notes
- La aplicación actualmente usa datos de ejemplo en memoria
- No hay integración con base de datos externa (Supabase fue removido)
- El build de producción funciona correctamente
- WebGL no está disponible en el entorno, la app usa renderizado CPU (funciona correctamente)
