import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({
    super.key,
    required this.userName,
    required this.email,
    required this.phone,
    required this.location,
    this.avatarImagePath,
    this.hasUnreadNotifications = false,
    this.onNotificationTap,
    this.onLogout,
    this.onViewProfile,
  });

  final String userName;
  final String email;
  final String phone;
  final String location;

  final String? avatarImagePath;
  final bool hasUnreadNotifications;

  final VoidCallback? onNotificationTap;
  final VoidCallback? onLogout;
  final VoidCallback? onViewProfile;

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with SingleTickerProviderStateMixin {
  bool _showProfileCard = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String get _initial {
    if (widget.userName.trim().isEmpty) return 'U';

    return widget.userName.trim()[0].toUpperCase();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    setState(() {
      _showProfileCard = !_showProfileCard;
    });

    if (_showProfileCard) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _closeProfile() {
    _controller.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showProfileCard = false;
        });
      }
    });
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE55353).withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFE55353),
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Logout?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D2A32),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Are you sure you want to logout from your account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF7A8580),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            side: const BorderSide(color: Color(0xFFE5E9E7)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFE55353),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (shouldLogout == true) {
      widget.onLogout?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// ================= MAIN HEADER =================
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE8ECEA)),
          ),
          child: Column(
            children: [
              /// TOP SECTION
              Row(
                children: [
                  /// PROFILE AVATAR
                  GestureDetector(
                    onTap: _toggleProfile,
                    child: Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary1,
                            AppColors.primary1.withValues(alpha: 0.60),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: const Color(0xFFF4F7F6),
                          child: widget.avatarImagePath != null
                              ? Image.asset(
                                  widget.avatarImagePath!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Text(
                                    _initial,
                                    style: TextStyle(
                                      color: AppColors.primary1,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// USER NAME
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back 👋',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B736F),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          widget.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1D2A32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// NOTIFICATION
                  _HeaderButton(
                    icon: Icons.notifications_none_rounded,
                    showBadge: widget.hasUnreadNotifications,
                    onTap: widget.onNotificationTap,
                  ),

                  const SizedBox(width: 8),

                  /// LOGOUT
                  _HeaderButton(
                    icon: Icons.logout_rounded,
                    isLogout: true,
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Divider(height: 1, color: Color(0xFFF0F2F1)),

              const SizedBox(height: 8),

              /// LOCATION
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary1.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary1,
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      widget.location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF59645F),
                      ),
                    ),
                  ),

                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7A8580),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// ================= PROFILE POPUP =================
        if (_showProfileCard) ...[
          /// OUTSIDE CLICK AREA
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeProfile,
              child: const SizedBox.expand(),
            ),
          ),

          /// PROFILE POPUP
          Positioned(
            top: 62,
            left: 0,
            child: GestureDetector(
              /// Popup click outside close ஆகாமல் இருக்க
              onTap: () {},
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  alignment: Alignment.topLeft,
                  child: _ProfilePopupCard(
                    userName: widget.userName,
                    email: widget.email,
                    phone: widget.phone,
                    onClose: _closeProfile,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfilePopupCard extends StatelessWidget {
  const _ProfilePopupCard({
    required this.userName,
    required this.email,
    required this.phone,
    required this.onClose,
  });

  final String userName;
  final String email;
  final String phone;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE8ECEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D2A32),
                  ),
                ),

                /// CANCEL / CLOSE ICON
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 19,
                        color: Color(0xFF7A8580),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Divider(height: 1, color: Color(0xFFF0F2F1)),

            const SizedBox(height: 10),

            /// NAME
            _ProfileInfoRow(
              icon: Icons.person_outline_rounded,
              label: 'Name',
              value: userName,
            ),

            const SizedBox(height: 16),

            /// EMAIL
            _ProfileInfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: email,
            ),

            const SizedBox(height: 16),

            /// PHONE
            _ProfileInfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: phone,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary1.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary1),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF8A9490)),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D2A32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.onTap,
    this.showBadge = false,
    this.isLogout = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool showBadge;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final bgColor = isLogout
        ? const Color(0xFFE55353).withValues(alpha: 0.08)
        : const Color(0xFFF4F7F6);

    final iconColor = isLogout
        ? const Color(0xFFE55353)
        : const Color(0xFF1D2A32);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 21, color: iconColor),

              if (showBadge)
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE55353),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF4F7F6),
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
