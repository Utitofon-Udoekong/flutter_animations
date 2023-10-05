
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class SliderPainter extends CustomPainter{
  final double sliderPosition;
  final double dragPercentage;

  Paint anchorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  double _previousSliderPosition = 0.0;

  SliderPainter({required this.sliderPosition, required this.dragPercentage});
  @override
  void paint(Canvas canvas, Size size) {
    _paintWaveLine(canvas, size, _calculateWaveLineDefinitions(size));
  }
  _paintThumb(Canvas canvas, Size size){
    final center = Offset(sliderPosition == size.width ? sliderPosition - 15 : sliderPosition , size.height / 2);
    canvas.drawCircle(center, 10, Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill);
  }

  _paintWaveLine(Canvas canvas, Size size, WaveCurveDefinitions waveCurve) {
    Path path = Path();
    Paint sliderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 6.0
      ..shader = ui.Gradient.radial(
          Offset(sliderPosition, 0), // center
          500, // radius
          [Colors.orange, Colors.purple, Colors.blue], // colors
          [0, 0.5, 1.0],
        );
    path.moveTo(0.0, size.height);
    path.lineTo(waveCurve.startOfBezier, size.height);
    path.cubicTo(
        waveCurve.leftControlPoint1,
        size.height,
        waveCurve.leftControlPoint2,
        waveCurve.controlHeight,
        waveCurve.centerPoint,
        waveCurve.controlHeight);
    _paintThumb(canvas, size);
    path.cubicTo(
        waveCurve.rightControlPoint1,
        waveCurve.controlHeight,
        waveCurve.rightControlPoint2,
        size.height,
        waveCurve.endOfBezier,
        size.height);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, sliderPaint);
  }

  WaveCurveDefinitions _calculateWaveLineDefinitions(Size size) {

    double controlHeight = 0.0;

    double bendWidth = 30 + 30 * dragPercentage;
    double bezierWidth = 30 + 30 * dragPercentage;

    double centerPoint = sliderPosition;
    centerPoint = (centerPoint > size.width) ? size.width : centerPoint;

    double startOfBend = centerPoint - bendWidth / 2;
    double startOfBezier = startOfBend - bezierWidth;
    double endOfBend = sliderPosition + bendWidth / 2;
    double endOfBezier = endOfBend + bezierWidth;

    startOfBend = (startOfBend <= 0.0) ? 0.0 : startOfBend;
    startOfBezier = (startOfBezier <= 0.0) ? 0.0 : startOfBezier;
    endOfBend = (endOfBend > size.width) ? size.width : endOfBend;
    endOfBezier = (endOfBezier > size.width) ? size.width : endOfBezier;

    double leftBendControlPoint1 = startOfBend;
    double leftBendControlPoint2 = startOfBend;
    double rightBendControlPoint1 = endOfBend;
    double rightBendControlPoint2 = endOfBend;

    double bendability = 25.0;
    double maxSlideDifference = 30.0;
    double slideDifference = (sliderPosition - _previousSliderPosition).abs();

    slideDifference = (slideDifference > maxSlideDifference)
        ? maxSlideDifference
        : slideDifference;

    double bend =
        ui.lerpDouble(0.0, bendability, slideDifference / maxSlideDifference)!;
    bool moveLeft = sliderPosition < _previousSliderPosition;
    bend = moveLeft ? -bend : bend;

    if(moveLeft){

      leftBendControlPoint1 = leftBendControlPoint1 - bend;
      leftBendControlPoint2 = leftBendControlPoint2 + bend;
      rightBendControlPoint1 = rightBendControlPoint1 + bend;
      rightBendControlPoint2 = rightBendControlPoint2 - bend;

      centerPoint = centerPoint + bend;
    }else{
      leftBendControlPoint1 = leftBendControlPoint1 + bend;
      leftBendControlPoint2 = leftBendControlPoint2 - bend;
      rightBendControlPoint1 = rightBendControlPoint1 - bend;
      rightBendControlPoint2 = rightBendControlPoint2 + bend;

      centerPoint = centerPoint - bend;
    }


    WaveCurveDefinitions waveCurveDefinitions = WaveCurveDefinitions(
      controlHeight: controlHeight,
      startOfBezier: startOfBezier,
      endOfBezier: endOfBezier,
      leftControlPoint1: leftBendControlPoint1,
      leftControlPoint2: leftBendControlPoint2,
      rightControlPoint1: rightBendControlPoint1,
      rightControlPoint2: rightBendControlPoint2,
      centerPoint: centerPoint,
    );

    return waveCurveDefinitions;
  }


  @override
  bool shouldRepaint(covariant SliderPainter oldDelegate) {
     double diff = _previousSliderPosition - oldDelegate.sliderPosition;
    if (diff.abs() > 20) {
      _previousSliderPosition = sliderPosition;
    } else {
      _previousSliderPosition = oldDelegate.sliderPosition;
    }
    return true;
  }

}

class WaveCurveDefinitions {
  double startOfBezier;
  double endOfBezier;
  double leftControlPoint1;
  double leftControlPoint2;
  double rightControlPoint1;
  double rightControlPoint2;
  double controlHeight;
  double centerPoint;

  WaveCurveDefinitions({
    required this.startOfBezier,
    required this.endOfBezier,
    required this.leftControlPoint1,
    required this.leftControlPoint2,
    required this.rightControlPoint1,
    required this.rightControlPoint2,
    required this.controlHeight,
    required this.centerPoint,
  });
}