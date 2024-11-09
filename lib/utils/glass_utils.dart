import 'dart:ui';
import 'package:flutter/material.dart';

extension ColorUtils on Color {
  List<Color> get darkGlassGradient => [
        withOpacity(0.3),
        withOpacity(0.2),
      ];
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double blur;
  final Color? gradientColor;
  final BorderRadius? customBorderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.blur = 10,
    this.gradientColor,
    this.customBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColor?.darkGlassGradient ??
                  [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.2),
                  ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                customBorderRadius ?? BorderRadius.circular(borderRadius),
            border: Border.all(
              color: (gradientColor ?? Colors.white).withOpacity(0.2),
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color? gradientColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.elevation = 8,
    this.gradientColor,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(elevation, elevation),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            GlassContainer(
              gradientColor: gradientColor,
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? gradientColor;
  final double width;
  final double height;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradientColor,
    this.width = 200,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (gradientColor ?? Colors.white).withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: GlassContainer(
          gradientColor: gradientColor,
          borderRadius: 25,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Color? gradientColor;
  final TextInputType? keyboardType;
  final bool obscureText;
  final List<String>? autofillHints; // Add this
  final VoidCallback? onEditingComplete; // Add this

  const GlassTextField({
    super.key,
    this.controller,
    this.hintText,
    this.gradientColor,
    this.keyboardType,
    this.obscureText = false,
    this.autofillHints, // Add this
    this.onEditingComplete, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      gradientColor: gradientColor,
      borderRadius: 25,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        autofillHints: autofillHints, // Add this
        onEditingComplete: onEditingComplete, // Add this
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? gradientColor;
  final VoidCallback? onLeading;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.gradientColor,
    this.onLeading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (gradientColor ?? Colors.white).withOpacity(0.9),
                (gradientColor ?? Colors.white).withOpacity(0.8),
              ],
            ),
          ),
          child: AppBar(
            title: Text(title, style: const TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: onLeading != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onLeading,
                  )
                : null,
            actions: actions,
          ),
        ),
      ),
    );
  }
}

class GlassBadge extends StatelessWidget {
  final Widget child;
  final String count;
  final Color? gradientColor;

  const GlassBadge({
    super.key,
    required this.child,
    required this.count,
    this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (count.isNotEmpty)
          Positioned(
            right: 0,
            top: 0,
            child: GlassContainer(
              gradientColor: gradientColor ?? Colors.red,
              padding: const EdgeInsets.all(4),
              borderRadius: 12,
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
