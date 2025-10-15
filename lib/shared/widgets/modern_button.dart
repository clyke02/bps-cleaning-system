import 'package:flutter/material.dart';
import '../../core/constants/app_styles.dart';

/// 🔘 Modern Gradient Button
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? AppSizes.buttonHeightL,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: AppShadows.colored,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: AppColors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔳 Icon Button with Background
class IconButtonWithBackground extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const IconButtonWithBackground({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        boxShadow: AppShadows.small,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: size ?? AppSizes.iconM,
            ),
          ),
        ),
      ),
    );
  }
}

/// ⭐ Chip Button
class ChipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
  final IconData? icon;
  final Color? selectedColor;

  const ChipButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isSelected = false,
    this.icon,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? color : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
        boxShadow: isSelected ? AppShadows.small : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusCircular),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingS,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected ? AppColors.white : color,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : color,
                    fontSize: AppSizes.fontS,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🎯 Floating Action Button Modern
class ModernFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Gradient? gradient;
  final String? label;

  const ModernFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.gradient,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(
          label != null ? AppSizes.radiusXL : AppSizes.radiusCircular,
        ),
        boxShadow: AppShadows.large,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(
            label != null ? AppSizes.radiusXL : AppSizes.radiusCircular,
          ),
          child: Padding(
            padding: EdgeInsets.all(
              label != null ? AppSizes.paddingM : AppSizes.paddingL,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.white, size: 24),
                if (label != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    label!,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppSizes.fontM,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
