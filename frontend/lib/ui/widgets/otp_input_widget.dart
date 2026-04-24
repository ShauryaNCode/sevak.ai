// lib/ui/widgets/otp_input_widget.dart
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';

/// Custom six-digit OTP input built without third-party dependencies.
///
/// This widget depends only on core Flutter primitives. It preserves a single
/// hidden text input as the source of truth, while rendering gesture-driven
/// boxes that reflect the current cursor and completion state.
class OtpInputWidget extends StatefulWidget {
  /// Creates the OTP input widget.
  const OtpInputWidget({
    required this.onCompleted,
    this.onChanged,
    super.key,
  });

  /// Called when all six OTP digits are entered.
  final ValueChanged<String> onCompleted;

  /// Called whenever the OTP value changes.
  final ValueChanged<String>? onChanged;

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String value = _controller.text;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double gap = AppSpacing.sm;
        const double maxBoxWidth = 48;
        const double minBoxWidth = 40;
        final double availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : (maxBoxWidth * 6) + (gap * 5);
        final double computedBoxWidth =
            (availableWidth - (gap * 5)) / 6;
        final double boxWidth = computedBoxWidth.clamp(minBoxWidth, maxBoxWidth);
        final List<Widget> boxes = <Widget>[];

        for (int index = 0; index < 6; index++) {
          final bool isFilled = index < value.length;
          final bool isActive =
              _focusNode.hasFocus && index == value.length.clamp(0, 5);

          boxes.add(
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: boxWidth,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? AppColors.primaryBlue : AppColors.neutral200,
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Text(
                isFilled ? value[index] : '',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.neutral800,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );

          if (index < 5) {
            boxes.add(const SizedBox(width: gap));
          }
        }

        return GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 1,
                  width: 1,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    maxLength: 6,
                    decoration: const InputDecoration(counterText: ''),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: boxes,
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTextChanged() {
    final String sanitized = _controller.text.replaceAll(RegExp(r'\D'), '');
    final String digitsOnly =
        sanitized.substring(0, sanitized.length.clamp(0, 6));

    if (digitsOnly != _controller.text) {
      _controller.value = TextEditingValue(
        text: digitsOnly,
        selection: TextSelection.collapsed(offset: digitsOnly.length),
      );
      return;
    }

    widget.onChanged?.call(digitsOnly);
    if (digitsOnly.length == 6) {
      widget.onCompleted(digitsOnly);
    }
    setState(() {});
  }
}
