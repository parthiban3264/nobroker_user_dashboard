import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({
    super.key,
    this.hintText = 'Search properties...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Search Field
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE8ECEA)),
            ),
            child: TextField(
              autofocus: false,
              cursorColor: AppColors.primary1,
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1D2A32)),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 21,
                  color: AppColors.primary1,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// Filter Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary1,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 21,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
