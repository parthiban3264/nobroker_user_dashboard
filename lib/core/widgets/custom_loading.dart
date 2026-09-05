import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomLoading extends StatelessWidget {
  final String message;

  const CustomLoading({super.key, this.message = 'Loading users...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary1,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A8580),
            ),
          ),
        ],
      ),
    );
  }
}
