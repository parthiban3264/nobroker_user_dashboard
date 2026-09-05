import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Bottom-of-dashboard trust section: 4 trust badges + a 24/7 support card.
///
/// Usage:
/// ```dart
/// DashboardTrustSection(onChatTap: () {})
/// ```
class DashboardTrustSection extends StatefulWidget {
  const DashboardTrustSection({super.key, this.onChatTap});

  final VoidCallback? onChatTap;

  @override
  State<DashboardTrustSection> createState() => _DashboardTrustSectionState();
}

class _DashboardTrustSectionState extends State<DashboardTrustSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  static const List<_TrustBadge> _badges = [
    _TrustBadge(icon: Icons.verified_outlined, label: 'Verified\nOwners'),
    _TrustBadge(icon: Icons.money_off_outlined, label: 'Zero\nBrokerage'),
    _TrustBadge(icon: Icons.support_agent_outlined, label: '24/7\nSupport'),
    _TrustBadge(icon: Icons.lock_outline, label: 'Secure\nPayments'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Trust badges row (4 items) ----
            SizedBox(height: 8),
            Row(
              children: List.generate(_badges.length, (index) {
                final badge = _badges[index];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == _badges.length - 1 ? 0 : 8,
                    ),
                    child: _BadgeChip(badge: badge),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustBadge {
  const _TrustBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badge});
  final _TrustBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 19, color: AppColors.primary1),
          const SizedBox(height: 6),
          Text(
            badge.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
