import 'package:flutter/material.dart';

class CSliderPainter extends CustomPainter{
  final Path path;

  CSliderPainter({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CSliderPainter oldDelegate) {
    return true;
  }

}