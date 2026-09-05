import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final double? width;
  final double? height;

  final IconData? icon;
  final bool iconOnRight;

  final bool isLoading;
  final bool buttonEnabled;

  final Gradient? gradient;
  final Color? backgroundColor;

  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.icon,
    this.iconOnRight = false,
    this.isLoading = false,
    this.buttonEnabled = false,
    this.gradient,
    this.backgroundColor,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 50;

    return SizedBox(
      height: buttonHeight,
      width: width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null
              ? (backgroundColor ?? AppColors.primary1)
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.white,
            elevation: 2,
            //shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    strokeCap: StrokeCap.round,
                    color: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                )
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (icon == null) {
      return Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!iconOnRight) ...[Icon(icon, size: 24), const SizedBox(width: 10)],
        SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        if (iconOnRight) ...[Spacer(), Icon(icon, size: 24)],
      ],
    );
  }
}
