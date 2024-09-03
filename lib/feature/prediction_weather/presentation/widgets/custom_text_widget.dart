import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final int fontSize;
  final Color color;

  const CustomTextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: fontSize.toDouble(),
          color: color,
        ),
      ),
    );
  }
}


class CustomTextWidgetBlack extends StatelessWidget {
  final String text;
  final int fontSize;
  final Color color;

  const CustomTextWidgetBlack({
    Key? key,
    required this.text,
    required this.fontSize,
    this.color = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: fontSize.toDouble(),
          color: color,
        ),
      ),
    );
  }
}

