// lib/features/authentication/domain/use_cases/request_otp_use_case.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../failures/auth_failure.dart';
import '../repositories/auth_repository.dart';

/// Validates, normalizes, and requests OTP delivery for phone-based login.
///
/// This use case depends on [AuthRepository] and guarantees the repository only
/// sees normalized Indian E.164 phone numbers.
@injectable
class RequestOtpUseCase {
  /// Creates the request-OTP use case.
  const RequestOtpUseCase(this._repository);

  final AuthRepository _repository;

  /// Validates and requests an OTP for the given phone number.
  Future<Either<AuthFailure, void>> call({required String phone}) async {
    final String? normalizedPhone = normalizeIndianPhone(phone);
    if (normalizedPhone == null) {
      return left(const AuthFailure.invalidPhone());
    }

    return _repository.requestOtp(phone: normalizedPhone);
  }

  /// Validates and normalizes an Indian phone number to E.164 format.
  ///
  /// TODO: Keep this logic aligned with backend validation rules if operator
  /// ranges or accepted fallback prefixes change in production.
  static String? normalizeIndianPhone(String input) {
    final String sanitized = input.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    String digits = sanitized;

    if (digits.startsWith('+')) {
      digits = digits.substring(1);
    }

    if (digits.startsWith('0') && digits.length == 11) {
      digits = digits.substring(1);
    }

    if (digits.startsWith('91') && digits.length == 12) {
      digits = digits.substring(2);
    }

    if (!RegExp(r'^\d{10}$').hasMatch(digits)) {
      return null;
    }

    if (!RegExp(r'^[6-9]').hasMatch(digits)) {
      return null;
    }

    return '+91$digits';
  }
}
