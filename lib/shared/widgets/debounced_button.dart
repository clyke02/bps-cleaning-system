import 'package:flutter/material.dart';
import 'dart:async';

class DebouncedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Duration debounceDuration;
  final ButtonStyle? style;

  const DebouncedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.style,
  });

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  Timer? _debounceTimer;
  bool _isProcessing = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handlePress() {
    if (_isProcessing) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (mounted && !_isProcessing) {
        setState(() {
          _isProcessing = true;
        });

        widget.onPressed?.call();

        // Reset processing state after a short delay
        Timer(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed != null && !_isProcessing ? _handlePress : null,
      style: widget.style,
      child: _isProcessing
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            )
          : widget.child,
    );
  }
}

// Optimized TextButton with debounce
class DebouncedTextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Duration debounceDuration;
  final ButtonStyle? style;

  const DebouncedTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.style,
  });

  @override
  State<DebouncedTextButton> createState() => _DebouncedTextButtonState();
}

class _DebouncedTextButtonState extends State<DebouncedTextButton> {
  Timer? _debounceTimer;
  bool _isProcessing = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handlePress() {
    if (_isProcessing) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (mounted && !_isProcessing) {
        setState(() {
          _isProcessing = true;
        });

        widget.onPressed?.call();

        Timer(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed != null && !_isProcessing ? _handlePress : null,
      style: widget.style,
      child: widget.child,
    );
  }
}
