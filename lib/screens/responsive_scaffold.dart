// lib/widgets/responsive_scaffold.dart
import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool hasGradient;
  final List<Color>? gradientColors;
  final PreferredSizeWidget? appBar;

  const ResponsiveScaffold({
    super.key,
    required this.child,
    this.backgroundColor,
    this.hasGradient = false,
    this.gradientColors,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.blue.shade900,
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          width: size.width,
          height: size.height,
          decoration:
              hasGradient
                  ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors ?? [Colors.blue.shade900, Colors.black],
                    ),
                  )
                  : BoxDecoration(color: backgroundColor),
          child: Padding(
            padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
            child: child,
          ),
        ),
      ),
    );
  }
}
