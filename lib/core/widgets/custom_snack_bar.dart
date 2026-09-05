import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final config = _getConfig(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              // ICON
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(config.icon, color: config.color, size: 22),
              ),

              const SizedBox(width: 12),

              // MESSAGE
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          backgroundColor: const Color(0xFF252525),

          behavior: behavior,

          duration: duration,

          margin: const EdgeInsets.all(16),

          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          elevation: 6,

          action: actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: config.color,
                  onPressed: onAction ?? () {},
                )
              : null,
        ),
      );
  }

  static _SnackBarConfig _getConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );

      case SnackBarType.error:
        return _SnackBarConfig(icon: Icons.error_outline, color: Colors.red);

      case SnackBarType.warning:
        return _SnackBarConfig(
          icon: Icons.warning_amber_outlined,
          color: Colors.orange,
        );

      case SnackBarType.info:
        return _SnackBarConfig(icon: Icons.info_outline, color: Colors.blue);
    }
  }
}

class _SnackBarConfig {
  final IconData icon;
  final Color color;

  const _SnackBarConfig({required this.icon, required this.color});
}
