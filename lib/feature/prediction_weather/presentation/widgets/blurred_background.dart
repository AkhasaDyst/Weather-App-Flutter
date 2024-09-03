import 'package:flutter/material.dart';
import 'dart:ui';

class BlurredBackground extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final double blurSigma;

  const BlurredBackground({
    Key? key,
    required this.backgroundColor,
    required this.child,
    required this.blurSigma,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
