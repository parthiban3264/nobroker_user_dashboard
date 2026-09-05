import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../models/user_model.dart';
import '../../view_models/auth/auth_bloc.dart';
import '../../view_models/auth/auth_event.dart';
import '../../view_models/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _imageFade;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _headingFade;
  late final Animation<Offset> _headingSlide;
  late final Animation<double> _subtextFade;
  late final Animation<Offset> _subtextSlide;
  late final Animation<double> _fieldsFade;
  late final Animation<Offset> _fieldsSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isPasswordVisible = false;
  String? emailError;
  String? passwordError;

  bool get isFormValid {
    return emailController.text.trim().isNotEmpty &&
        passwordController.text.length >= 6 &&
        emailError == null &&
        passwordError == null;
  }

  void _validateEmail(String value) {
    setState(() {
      emailError = Validators.validateEmail(value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      passwordError = Validators.validatePassword(value);
    });
  }

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
      curve: const Interval(0.35, 0.62, curve: Curves.easeOut),
    );
    _headingSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.35, 0.62, curve: Curves.easeOutCubic),
          ),
        );

    _subtextFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.44, 0.70, curve: Curves.easeOut),
    );
    _subtextSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.44, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _fieldsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
    );
    _fieldsSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.70, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      emailController.text = args['email'] ?? '';
      passwordController.text = args['password'] ?? '';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _login() {
    if (!isFormValid) return;

    context.read<AuthBloc>().add(
      LoginRequested(
        UserModel(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Login successful',
            type: SnackBarType.success,
            duration: Duration(milliseconds: 1000),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
        if (state is AuthError) {
          CustomSnackBar.show(
            context,
            message: state.msg,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;

        final bool buttonEnabled = isFormValid && !isLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                // ---- Background image — unchanged ----
                FadeTransition(
                  opacity: _imageFade,
                  child: Image.asset(
                    'assets/image/bg.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),

                // ---- App Logo — unchanged ----
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

                // ---- Form card, raised over the image for readability ----
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                    decoration: const BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 24,
                          offset: Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ---- Welcome Back heading ----
                        FadeTransition(
                          opacity: _headingFade,
                          child: SlideTransition(
                            position: _headingSlide,
                            child: Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FadeTransition(
                          opacity: _subtextFade,
                          child: SlideTransition(
                            position: _subtextSlide,
                            child: Text(
                              'Login to continue your property journey',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        FadeTransition(
                          opacity: _fieldsFade,
                          child: SlideTransition(
                            position: _fieldsSlide,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: emailController,
                                  primaryColor: AppColors.primary1,
                                  focusNode: emailFocus,
                                  hintText: 'Enter Email',
                                  prefixIcon: Icons.mail_outline,
                                  errorText: emailError,
                                  isFocused: emailFocus.hasFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onChanged: _validateEmail,
                                ),
                                const SizedBox(height: 16),

                                // PASSWORD
                                CustomTextField(
                                  controller: passwordController,
                                  primaryColor: AppColors.primary1,
                                  focusNode: passwordFocus,
                                  hintText: 'Enter Password',
                                  prefixIcon: Icons.lock_outline,
                                  errorText: passwordError,
                                  isFocused: passwordFocus.hasFocus,
                                  obscureText: !isPasswordVisible,
                                  textInputAction: TextInputAction.done,
                                  onChanged: _validatePassword,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    icon: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      transitionBuilder: (child, anim) =>
                                          ScaleTransition(
                                            scale: anim,
                                            child: child,
                                          ),
                                      child: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        key: ValueKey(isPasswordVisible),
                                        color: AppColors.primary1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        FadeTransition(
                          opacity: _fieldsFade,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forget Password ?',
                                  style: TextStyle(
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // ---- Login Button ----
                        FadeTransition(
                          opacity: _buttonFade,
                          child: SlideTransition(
                            position: _buttonSlide,
                            child: CustomButton(
                              isLoading: isLoading,
                              onPressed: buttonEnabled ? _login : null,
                              text: 'Login',
                              height: 58,
                              borderRadius: 30,
                              icon: Icons.arrow_forward_rounded,
                              iconOnRight: true,
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF263F3E), Color(0xFF102A29)],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // SIGN UP
                        FadeTransition(
                          opacity: _buttonFade,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account ?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.register,
                                  );
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
