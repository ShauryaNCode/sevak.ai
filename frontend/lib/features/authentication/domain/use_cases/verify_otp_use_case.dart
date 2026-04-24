// lib/features/authentication/domain/use_cases/verify_otp_use_case.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../entities/auth_user.dart';
import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

/// Verifies OTP input and persists the resulting authenticated session.
///
/// This use case depends on [AuthRepository] and guarantees OTP format
/// validation before reaching the data layer.
@injectable
class VerifyOtpUseCase {
  /// Creates the verify-OTP use case.
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  /// Verifies the OTP and saves the authenticated user on success.
  Future<Either<AuthFailure, AuthUser>> call({
    required String phone,
    required String otp,
  }) async {
    if (!isValidOtp(otp)) {
      return left(const AuthFailure.invalidOtp());
    }

    final Either<AuthFailure, AuthUser> result =
        await _repository.verifyOtp(phone: phone, otp: otp);

    switch (result) {
      case Left<AuthFailure, AuthUser>(value: final AuthFailure failure):
        return left(failure);
      case Right<AuthFailure, AuthUser>(value: final AuthUser user):
        await _repository.saveUser(user);
        return right(user);
    }
  }

  /// Validates the OTP format.
  ///
  /// TODO: If the backend OTP length changes, update this validation and the
  /// OTP input widget together to keep UX and API expectations aligned.
  static bool isValidOtp(String otp) {
    return RegExp(r'^\d{6}$').hasMatch(otp);
  }
}
