import 'package:flutter/material.dart';

/// Standard dialog widget untuk konsistensi UI di seluruh aplikasi
class CustomDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget content;
  final List<Widget>? actions;
  final EdgeInsets? contentPadding;
  final bool showCloseButton;

  const CustomDialog({
    super.key,
    this.title,
    this.titleWidget,
    required this.content,
    this.actions,
    this.contentPadding,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            if (title != null || titleWidget != null)
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          titleWidget ??
                          Text(
                            title!,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                    ),
                    if (showCloseButton)
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      ),
                  ],
                ),
              ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: content,
              ),
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
              ),
          ],
        ),
      ),
    );
  }
}

/// Standard alert dialog dengan icon
class CustomAlertDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String? cancelText;
  final String confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final bool showCancelButton;

  const CustomAlertDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.cancelText,
    this.confirmText = 'OK',
    this.onCancel,
    this.onConfirm,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 48, color: iconColor),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                if (showCancelButton) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel ?? () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        cancelText ?? 'Batal',
                        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm ?? () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: iconColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(confirmText, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading dialog
class CustomLoadingDialog extends StatelessWidget {
  final String message;

  const CustomLoadingDialog({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(strokeWidth: 3),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

/// Success dialog preset
class SuccessDialog extends CustomAlertDialog {
  const SuccessDialog({super.key, required super.title, required super.message, super.confirmText, super.onConfirm})
    : super(icon: Icons.check_circle, iconColor: Colors.green, showCancelButton: false);
}

/// Error dialog preset
class ErrorDialog extends CustomAlertDialog {
  const ErrorDialog({super.key, required super.title, required super.message, super.confirmText, super.onConfirm})
    : super(icon: Icons.error, iconColor: Colors.red, showCancelButton: false);
}

/// Warning/Confirmation dialog preset
class ConfirmDialog extends CustomAlertDialog {
  const ConfirmDialog({
    super.key,
    required super.title,
    required super.message,
    super.cancelText,
    super.confirmText = 'Ya',
    super.onCancel,
    super.onConfirm,
  }) : super(icon: Icons.warning_amber, iconColor: Colors.orange, showCancelButton: true);
}

/// Info dialog preset
class InfoDialog extends CustomAlertDialog {
  const InfoDialog({
    super.key,
    required super.title,
    required super.message,
    super.confirmText = 'Mengerti',
    super.onConfirm,
  }) : super(icon: Icons.info, iconColor: Colors.blue, showCancelButton: false);
}
