// lib/core/utils/phone_utils.dart

/// Shared phone-number formatting helpers.
class PhoneUtils {
  /// Prevents instantiation.
  const PhoneUtils._();

  /// Masks an Indian E.164 phone number for privacy-sensitive UI.
  static String maskPhone(String e164Phone) {
    final String digits = e164Phone.replaceAll(RegExp(r'\D'), '');
    final String normalized = digits.startsWith('91') && digits.length >= 12
        ? digits.substring(digits.length - 10)
        : digits.length >= 10
            ? digits.substring(digits.length - 10)
            : digits;

    if (normalized.length != 10) {
      return e164Phone;
    }

    return '+91 ${normalized.substring(0, 5)}•••••';
  }
}
