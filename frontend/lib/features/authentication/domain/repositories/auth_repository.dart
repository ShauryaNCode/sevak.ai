// lib/features/authentication/domain/repositories/auth_repository.dart
// pubspec comment: add fpdart: ^1.1.0 to dependencies.
import 'package:fpdart/fpdart.dart';

import '../entities/auth_user.dart';
import '../failures/auth_failure.dart';

/// Domain contract for OTP-based authentication workflows.
///
/// This repository abstracts remote auth APIs and secure local persistence so
/// use cases can validate inputs and coordinate session state without knowing
/// storage or network details.
abstract class AuthRepository {
  /// Requests an OTP for the given phone number.
  Future<Either<AuthFailure, void>> requestOtp({required String phone});

  /// Verifies the OTP and returns the authenticated user.
  Future<Either<AuthFailure, AuthUser>> verifyOtp({
    required String phone,
    required String otp,
  });

  /// Refreshes the access token for the current session.
  Future<Either<AuthFailure, String>> refreshToken();

  /// Logs out the current user and clears local auth state.
  Future<Either<AuthFailure, void>> logout();

  /// Returns the currently stored authenticated user, if any.
  Future<AuthUser?> getCurrentUser();

  /// Watches authentication state changes.
  Stream<AuthUser?> watchAuthState();

  /// Persists the authenticated user locally.
  Future<void> saveUser(AuthUser user);
}
