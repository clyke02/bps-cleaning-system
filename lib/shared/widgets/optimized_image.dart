import 'package:flutter/material.dart';

class OptimizedImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  const OptimizedImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      // Optimize for performance
      cacheWidth: width != null ? (width! * 2).round() : null,
      cacheHeight: height != null ? (height! * 2).round() : null,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }
}

// Optimized cache for image widgets
class ImageCache {
  static final Map<String, Widget> _cache = {};

  static Widget getOptimizedImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    final key = '$assetPath-$width-$height-$fit-$color';

    return _cache.putIfAbsent(
      key,
      () => OptimizedImage(assetPath: assetPath, width: width, height: height, fit: fit, color: color),
    );
  }

  static void clearCache() {
    _cache.clear();
  }
}
