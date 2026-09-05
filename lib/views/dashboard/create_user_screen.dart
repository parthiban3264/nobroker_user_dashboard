import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noBroker_user_dashboard/core/constants/app_colors.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../models/user_model.dart';
import '../../view_models/auth/auth_bloc.dart';
import '../../view_models/auth/auth_event.dart';
import '../../view_models/auth/auth_state.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fieldsFade;
  late final Animation<Offset> _fieldsSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  bool isPasswordVisible = false;
  String? emailError;
  String? phoneError;
  String? passwordError;

  bool get isFormValid {
    return emailController.text.trim().isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.length >= 6 &&
        emailError == null &&
        phoneError == null &&
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

  void _validatePhone(String value) {
    setState(() {
      phoneError = Validators.validatePhone(value);
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _fieldsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
    );
    _fieldsSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
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

    nameFocus.addListener(() => setState(() {}));
    phoneFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));

    _controller.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocus.dispose();
    phoneFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _register() {
    if (!isFormValid) return;

    context.read<AuthBloc>().add(
      RegisterRequested(
        UserModel(
          email: emailController.text.trim(),
          password: passwordController.text,
          name: nameController.text,
          phone: phoneController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Register successful',
            type: SnackBarType.success,
            duration: Duration(milliseconds: 1000),
          );
          Navigator.pop(context);
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
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFF7F9F8),

          appBar: CustomAppBar(
            title: 'Create User',
            backgroundColor: AppColors.primary1,
            titleColor: Colors.white,
            iconColor: Colors.white,
            centerTitle: false,
            leadingIcon: Icons.arrow_back_ios_new_rounded,
          ),

          body: SafeArea(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: ListView(
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 26,
                    ),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Color(0xFFE6EBE8)),
                    ),

                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Form Fields Animation
                          FadeTransition(
                            opacity: _fieldsFade,
                            child: SlideTransition(
                              position: _fieldsSlide,
                              child: Column(
                                children: [
                                  /// Header
                                  Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary1.withValues(
                                            alpha: 0.10,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person_add_alt_1_rounded,
                                          color: AppColors.primary1,
                                          size: 22,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'New User',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1D2A32),
                                              ),
                                            ),

                                            SizedBox(height: 3),

                                            Text(
                                              'Enter the user details below',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF7A8580),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  const Divider(
                                    color: Color(0xFFEFF2F0),
                                    height: 1,
                                  ),

                                  const SizedBox(height: 20),

                                  CustomTextField(
                                    controller: nameController,
                                    primaryColor: AppColors.primary1,
                                    focusNode: nameFocus,
                                    hintText: 'Full Name',
                                    prefixIcon: Icons.person_outline_rounded,
                                    isFocused: nameFocus.hasFocus,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                  ),

                                  const SizedBox(height: 14),

                                  CustomTextField(
                                    controller: phoneController,
                                    primaryColor: AppColors.primary1,
                                    focusNode: phoneFocus,
                                    hintText: 'Phone Number',
                                    prefixIcon: Icons.phone_outlined,
                                    errorText: phoneError,
                                    isFocused: phoneFocus.hasFocus,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    onChanged: _validatePhone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  CustomTextField(
                                    controller: emailController,
                                    primaryColor: AppColors.primary1,
                                    focusNode: emailFocus,
                                    hintText: 'Email Address',
                                    prefixIcon: Icons.mail_outline_rounded,
                                    errorText: emailError,
                                    isFocused: emailFocus.hasFocus,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onChanged: _validateEmail,
                                  ),

                                  const SizedBox(height: 14),

                                  CustomTextField(
                                    controller: passwordController,
                                    primaryColor: AppColors.primary1,
                                    focusNode: passwordFocus,
                                    hintText: 'Create Password',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    errorText: passwordError,
                                    isFocused: passwordFocus.hasFocus,
                                    obscureText: !isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    onChanged: _validatePassword,

                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.primary1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// Register Button Animation
                          FadeTransition(
                            opacity: _buttonFade,
                            child: SlideTransition(
                              position: _buttonSlide,
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  isLoading: isLoading,
                                  onPressed: buttonEnabled ? _register : null,
                                  text: 'Create User',
                                  height: 52,
                                  borderRadius: 14,
                                  icon: Icons.person_add_alt_1_rounded,
                                  iconOnRight: false,

                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.primary1,
                                      const Color(0xFF102A29),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
