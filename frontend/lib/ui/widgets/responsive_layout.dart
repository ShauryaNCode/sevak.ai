// C:\Users\th366\Desktop\sevakai\frontend\lib\ui\widgets\responsive_layout.dart
import 'package:flutter/material.dart';

/// Switches between mobile, tablet, and desktop layouts using width breakpoints.
class ResponsiveLayout extends StatelessWidget {
  /// Creates a responsive layout wrapper.
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    required this.desktop,
    super.key,
  });

  /// Mobile layout for narrow widths.
  final Widget mobile;

  /// Optional tablet layout for medium widths.
  final Widget? tablet;

  /// Desktop layout for wide widths.
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 1024) {
          return desktop;
        }
        if (constraints.maxWidth >= 600) {
          return tablet ?? desktop;
        }
        return mobile;
      },
    );
  }
}
