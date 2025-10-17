import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

/// 🎬 Modern Animation Helpers
class AnimationHelper {
  /// Fade In Animation
  static Widget fadeIn(
    Widget child, {
    Duration duration = AppSizes.durationNormal,
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: child,
    );
  }

  /// Slide In from Bottom
  static Widget slideInFromBottom(
    Widget child, {
    Duration duration = AppSizes.durationNormal,
    double offset = 30.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, offset * value),
          child: Opacity(opacity: 1 - value, child: child),
        );
      },
      child: child,
    );
  }

  /// Scale Animation
  static Widget scaleIn(
    Widget child, {
    Duration duration = AppSizes.durationNormal,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  /// Shimmer Loading Effect
  static Widget shimmer(
    Widget child, {
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1.0, end: 2.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              transform: _SlidingGradientTransform(slidePercent: value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// 🎨 Custom Page Transitions
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;

  SlidePageRoute({required this.page, this.direction = AxisDirection.left})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin;
          switch (direction) {
            case AxisDirection.up:
              begin = const Offset(0.0, 1.0);
              break;
            case AxisDirection.down:
              begin = const Offset(0.0, -1.0);
              break;
            case AxisDirection.right:
              begin = const Offset(-1.0, 0.0);
              break;
            case AxisDirection.left:
              begin = const Offset(1.0, 0.0);
              break;
          }

          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: AppSizes.durationNormal,
      );
}

/// Fade Page Transition
class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppSizes.durationFast,
      );
}

/// Scale + Fade Transition
class ScalePageRoute extends PageRouteBuilder {
  final Widget page;

  ScalePageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.8;
          const end = 1.0;
          const curve = Curves.easeOutCubic;

          var scaleTween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return ScaleTransition(
            scale: animation.drive(scaleTween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: AppSizes.durationNormal,
      );
}
