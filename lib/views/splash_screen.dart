import 'package:flutter/material.dart';
import 'package:noBroker_user_dashboard/core/constants/app_colors.dart';

import '../app/routes.dart';
import '../core/storage/flutter_secure_storage.dart';
import '../core/widgets/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _imageFade;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;
  late final Animation<double> _subtextFade;
  late final Animation<Offset> _subtextSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _imageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.5, curve: Curves.easeOut),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 0.5, curve: Curves.easeOutCubic),
          ),
        );

    _headingFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
    );
    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.35, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    _subtextFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.85, curve: Curves.easeOut),
    );
    _subtextSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
    _checkAuth();
  }

  //check for token is
  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final token = await TokenStorage.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            FadeTransition(
              opacity: _imageFade,
              child: Image.asset(
                'assets/image/bg.png',
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            // App Logo
            Positioned(
              top: 12,
              left: 8,
              child: FadeTransition(
                opacity: _logoFade,
                child: SlideTransition(
                  position: _logoSlide,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image/logo.png',
                        height: 65,
                        width: 80,
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        'PropEase',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Content
            Positioned(
              bottom: 46,
              left: 20,
              right: 24,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _headingFade,
                    child: SlideTransition(
                      position: _headingSlide,
                      child: const Text(
                        'Discover Your\nDream Home',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: AppColors.primary1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  FadeTransition(
                    opacity: _subtextFade,
                    child: SlideTransition(
                      position: _subtextSlide,
                      child: const Text(
                        'Find the perfect property with ease.\n'
                        'Explore, compare and connect with\n'
                        'trusted agents in one app',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Color(0xFF5E666B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Get Started Button
                  FadeTransition(
                    opacity: _buttonFade,
                    child: SlideTransition(
                      position: _buttonSlide,
                      child: CustomButton(
                        isLoading: isLoading,
                        text: isLoading ? 'Signing you in...' : 'Get Started',
                        height: 58,
                        borderRadius: 30,
                        icon: Icons.arrow_forward_rounded,
                        iconOnRight: true,
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF263F3E), Color(0xFF102A29)],
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(context, AppRoutes.login);
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
