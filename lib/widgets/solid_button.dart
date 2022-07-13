import 'package:cricland_admin/constants/static_colors.dart';
import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Color color;
  final VoidCallback? onPressed;
  final Widget child;

  const SolidButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.color = StaticColor.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          primary: color,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: child,
      ),
    );
  }
}