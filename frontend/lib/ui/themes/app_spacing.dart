// lib/ui/themes/app_spacing.dart
import 'package:flutter/material.dart';

/// Centralized spacing tokens based on an 8px grid.
abstract final class AppSpacing {
  /// Prevents instantiation.
  const AppSpacing._();

  /// Extra-small spacing token.
  static const double xs = 4;

  /// Small spacing token.
  static const double sm = 8;

  /// Medium spacing token.
  static const double md = 16;

  /// Large spacing token.
  static const double lg = 24;

  /// Extra-large spacing token.
  static const double xl = 32;

  /// Double extra-large spacing token.
  static const double xxl = 48;

  /// Triple extra-large spacing token.
  static const double xxxl = 64;
}

/// Centralized radius tokens for shape styling.
abstract final class AppRadius {
  /// Prevents instantiation.
  const AppRadius._();

  /// Small corner radius token.
  static const double sm = 4;

  /// Medium corner radius token.
  static const double md = 8;

  /// Large corner radius token.
  static const double lg = 12;

  /// Extra-large corner radius token.
  static const double xl = 16;

  /// Fully rounded radius token for pills and avatars.
  static const double full = 999;
}

/// Centralized shadow tokens for elevation styling.
abstract final class AppShadows {
  /// Prevents instantiation.
  const AppShadows._();

  /// No-shadow elevation token.
  static const List<BoxShadow> none = <BoxShadow>[
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 0,
      color: Colors.transparent,
    ),
  ];

  /// Small elevation token.
  static const List<BoxShadow> sm = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
      color: Color(0x14000000),
    ),
  ];

  /// Medium elevation token.
  static const List<BoxShadow> md = <BoxShadow>[
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
  ];

  /// Large elevation token.
  static const List<BoxShadow> lg = <BoxShadow>[
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      color: Color(0x1A000000),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
      color: Color(0x0D000000),
    ),
  ];
}
