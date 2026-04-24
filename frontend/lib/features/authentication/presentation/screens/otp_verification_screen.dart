// C:\Users\th366\Desktop\sevakai\frontend\lib\features\authentication\presentation\screens\otp_verification_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/route_constants.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';
import '../../../../ui/widgets/otp_input_widget.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/failures/auth_failure.dart';
import '../bloc/auth_bloc.dart';

/// OTP verification screen for completing phone-based authentication.
///
/// This screen depends on [AuthBloc] and a custom OTP widget. It manages local
/// resend countdown timing while delegating verification and resend operations
/// to the authentication BLoC.
class OtpVerificationScreen extends StatefulWidget {
  /// Creates the OTP verification screen.
  const OtpVerificationScreen({
    required this.phone,
    super.key,
  });

  /// Normalized E.164 phone number being verified.
  final String phone;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _resendTimer;
  int _resendCountdown = 30;
  String _otp = '';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          current is AuthAuthenticated || current is AuthFailureState,
      buildWhen: (AuthState previous, AuthState current) =>
          current is AuthLoading ||
          current is AuthFailureState ||
          current is AuthOtpSent ||
          current is AuthInitial ||
          current is AuthUnauthenticated,
      listener: (BuildContext context, AuthState state) {
        state.whenOrNull(
          authenticated: (user) {
            if (user.role == UserRole.volunteer) {
              context.go(AppRoutes.volunteerDashboard);
            } else {
              context.go(AppRoutes.coordinatorDashboard);
            }
          },
          failure: (AuthFailure failure) async {
            setState(() {
              _errorText = failure.userMessage;
            });
            await failure.whenOrNull(
              otpExpired: () async {
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('OTP expired'),
                      content: const Text(
                        'OTP expired. Request a new one.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                if (!context.mounted) {
                  return;
                }
                context.go(AppRoutes.login);
              },
            );
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
                      child: Text(
                        'Verify your OTP',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.neutral900,
                        ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'OTP sent to ${PhoneUtils.maskPhone(widget.phone)}',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.neutral600,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              OtpInputWidget(
                                onChanged: (String otp) {
                                  setState(() {
                                    _otp = otp;
                                    _errorText = null;
                                  });
                                },
                                onCompleted: (String otp) {
                                  setState(() {
                                    _otp = otp;
                                  });
                                  _verify();
                                },
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isLoading || _otp.length != 6
                                      ? null
                                      : _verify,
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator.adaptive(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Verify OTP',
                                          style: AppTextStyles.titleMedium
                                              .copyWith(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              TextButton(
                                onPressed:
                                    _resendCountdown > 0 || isLoading ? null : _resend,
                                child: Text(
                                  _resendCountdown > 0
                                      ? 'Resend OTP (${_formatCountdown(_resendCountdown)})'
                                      : 'Resend OTP',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: _resendCountdown > 0
                                        ? AppColors.neutral400
                                        : AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.pop(),
                                child: Text(
                                  'Wrong number? Change',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                              if (_errorText != null)
                                Text(
                                  _errorText!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.dangerRed,
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

  void _verify() {
    context.read<AuthBloc>().add(
          AuthEvent.otpVerified(phone: widget.phone, otp: _otp),
        );
  }

  void _resend() {
    context.read<AuthBloc>().add(
          AuthEvent.otpRequested(phone: widget.phone),
        );
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() {
      _resendCountdown = 30;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        setState(() {
          _resendCountdown = 0;
        });
        return;
      }
      setState(() {
        _resendCountdown -= 1;
      });
    });
  }

  String _formatCountdown(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
