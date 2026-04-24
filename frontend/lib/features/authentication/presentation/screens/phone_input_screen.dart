// C:\Users\th366\Desktop\sevakai\frontend\lib\features\authentication\presentation\screens\phone_input_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/route_constants.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/failures/auth_failure.dart';
import '../bloc/auth_bloc.dart';

/// Entry screen for phone-based OTP authentication.
///
/// This screen depends on [AuthBloc] and provides a validated Indian mobile
/// number form. It keeps rate-limit countdown state locally while delegating
/// OTP request orchestration to the BLoC.
class PhoneInputScreen extends StatefulWidget {
  /// Creates the phone input screen.
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  Timer? _retryTimer;
  int _retryAfterSeconds = 0;
  String? _errorText;

  @override
  void dispose() {
    _retryTimer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          current is AuthOtpSent ||
          current is AuthFailureState ||
          current is AuthAuthenticated,
      buildWhen: (AuthState previous, AuthState current) =>
          current is AuthLoading ||
          current is AuthFailureState ||
          current is AuthInitial ||
          current is AuthUnauthenticated,
      listener: (BuildContext context, AuthState state) {
        state.whenOrNull(
          otpSent: (String phone) {
            setState(() {
              _errorText = null;
            });
            context.go(
              '${AppRoutes.otpVerification}?phone=${Uri.encodeComponent(phone)}',
            );
          },
          failure: (AuthFailure failure) {
            setState(() {
              _errorText = failure.userMessage;
            });
            failure.whenOrNull(
              rateLimited: (int retryAfterSeconds) {
                _startRetryCountdown(retryAfterSeconds);
              },
            );
          },
          authenticated: (user) {
            if (user.role == UserRole.volunteer) {
              context.go(AppRoutes.volunteerDashboard);
            } else {
              context.go(AppRoutes.coordinatorDashboard);
            }
          },
        );
      },
      builder: (BuildContext context, AuthState state) {
        final bool isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.neutral50,
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: constraints.maxHeight * 0.4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'S',
                              style: AppTextStyles.displayMedium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Serving those who serve',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.neutral600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 6,
                            spreadRadius: -1,
                            color: Color(0x1A000000),
                          ),
                          BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            spreadRadius: -1,
                            color: Color(0x0F000000),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Sign in with OTP',
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: AppColors.neutral900,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Enter your mobile number to continue.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.neutral600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Form(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Mobile number',
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            '🇮🇳',
                                            style: AppTextStyles.titleLarge,
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          Text(
                                            '+91',
                                            style: AppTextStyles.bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    prefixIconConstraints:
                                        const BoxConstraints(minWidth: 96),
                                    hintText: '9876543210',
                                  ),
                                  validator: (String? value) {
                                    if ((value ?? '').length < 10) {
                                      return 'Enter a valid 10-digit mobile number.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isLoading || _retryAfterSeconds > 0
                                      ? null
                                      : _submit,
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child:
                                              CircularProgressIndicator.adaptive(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Send OTP',
                                          style: AppTextStyles.titleMedium
                                              .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              if (_errorText != null)
                                Text(
                                  _errorText!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.dangerRed,
                                  ),
                                ),
                              if (_retryAfterSeconds > 0) ...<Widget>[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Retry in ${_formatCountdown(_retryAfterSeconds)}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.dangerRed,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.xxl),
                              Center(
                                child: Text(
                                  'Emergency helpline: 112',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.neutral400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          AuthEvent.otpRequested(phone: _phoneController.text.trim()),
        );
  }

  void _startRetryCountdown(int seconds) {
    _retryTimer?.cancel();
    setState(() {
      _retryAfterSeconds = seconds;
    });
    _retryTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_retryAfterSeconds <= 1) {
        timer.cancel();
        setState(() {
          _retryAfterSeconds = 0;
        });
        return;
      }

      setState(() {
        _retryAfterSeconds -= 1;
      });
    });
  }

  String _formatCountdown(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
