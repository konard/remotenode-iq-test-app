import 'package:flutter/material.dart';

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Extension for responsive sizing
extension ResponsiveExtension on BuildContext {
  /// Screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if device is mobile
  bool get isMobile => screenWidth < Breakpoints.mobile;

  /// Check if device is tablet
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;

  /// Check if device is desktop
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  /// Get padding based on screen size
  double get horizontalPadding {
    if (isMobile) return 16;
    if (isTablet) return 32;
    return 48;
  }

  /// Get card width based on screen size
  double get cardWidth {
    if (isMobile) return screenWidth - 32;
    if (isTablet) return 500;
    return 600;
  }

  /// Get number of columns for grid
  int get gridColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }
}

/// Responsive wrapper widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.tablet) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= Breakpoints.mobile) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// Responsive container that centers content with max width
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 800,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
