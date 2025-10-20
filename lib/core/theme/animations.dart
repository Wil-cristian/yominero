import 'package:flutter/material.dart';

/// Curves personalizadas para animaciones premium
class AppCurves {
  AppCurves._();
  
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeOutQuart = Curves.easeOutQuart;
  static const Curve easeInOutQuart = Curves.easeInOutQuart;
  static const Curve elasticOut = Curves.elasticOut;
  
  // Curve personalizada para fade + scale suave
  static const Curve premiumEntry = Cubic(0.25, 0.46, 0.45, 0.94);
  static const Curve smoothExit = Cubic(0.55, 0.06, 0.68, 0.19);
}

/// Duraciones estándar para consistencia
class AppDurations {
  AppDurations._();
  
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration pageTransition = Duration(milliseconds: 350);
}

/// Widget animado que aparece con fade y slide desde abajo
class FadeInSlide extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double offset;

  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = AppCurves.premiumEntry,
    this.offset = 20.0,
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, widget.offset),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Widget animado con scale y fade
class ScaleFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double initialScale;

  const ScaleFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.delay = Duration.zero,
    this.curve = AppCurves.easeOutQuart,
    this.initialScale = 0.9,
  });

  @override
  State<ScaleFadeIn> createState() => _ScaleFadeInState();
}

class _ScaleFadeInState extends State<ScaleFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _scale = Tween<double>(begin: widget.initialScale, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

/// Botón animado con efecto de press
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double scaleOnPress;
  final Duration duration;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.scaleOnPress = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleOnPress : 1.0,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}

/// Animación de shimmer para loading states
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerPosition = _controller.value;
        final start = (shimmerPosition - 0.3).clamp(0.0, 1.0);
        final center = shimmerPosition.clamp(0.0, 1.0);
        final end = (shimmerPosition + 0.3).clamp(0.0, 1.0);
        
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [start, center, end],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
