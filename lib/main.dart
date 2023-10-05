import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AnimatedSlideExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnimatedSlideExample extends StatefulWidget {
  const AnimatedSlideExample({super.key});

  @override
  State<AnimatedSlideExample> createState() => _AnimatedSlideExampleState();
}

class _AnimatedSlideExampleState extends State<AnimatedSlideExample> {
  Offset offset = const Offset(0, 0);
  Offset dragOffset = const Offset(0,0);
  double initial = 0.0;
  double percentage = 0.0;

  // _onTapDown(TapDownDetails details) {
  //   var y = (details.globalPosition.dy / MediaQuery.of(context).size.height) * 100;
  //   print("tap down " + y.toString());
  //   setState(() {
  //     dragOffset = Offset(dragOffset.dx, y);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedSlide Sample')),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      verticalDirection: VerticalDirection.up,
                      children: List.generate(11, (index) {
                        return Text(
                          "${(index * 10)}%",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15, height: 1.0),
                        )
                            .animate(
                                target:
                                    ((offset.dy / 10).round() == index) ? 1 : 0)
                            .scaleXY(
                                begin: 1.0,
                                end: 2,
                                alignment: Alignment.centerLeft)
                            .tint(begin: 0, end: 1, color: Colors.blue);
                      }),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackShape: CustomSliderTrackShape(),
                              thumbShape: CustomThumb()
                            ),
                            child: Slider(
                              min: 0,
                              max: 100,
                              value: offset.dy,
                              onChanged: (double value) {
                                setState(() {
                                  offset = Offset(offset.dx, value);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _debugDrawShadow(Canvas canvas, Path path, double elevation) {
  if (elevation > 0.0) {
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = elevation * 2.0,
    );
  }
}

class CustomThumb extends SliderComponentShape{
  @override
  ui.Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(15);
  }

  @override
  void paint(PaintingContext context, ui.Offset center, {required Animation<double> activationAnimation, required Animation<double> enableAnimation, required bool isDiscrete, required TextPainter labelPainter, required RenderBox parentBox, required SliderThemeData sliderTheme, required ui.TextDirection textDirection, required double value, required double textScaleFactor, required ui.Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: 15,
      end: 15,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final Color color = Colors.white;
    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: 0,
      end: 3,
    );

    final double evaluatedElevation = elevationTween.evaluate(activationAnimation);
    final trackRect = sliderTheme.trackShape!.getPreferredRect(parentBox: parentBox, sliderTheme: sliderTheme);
    final Offset thumbCenter = Offset((trackRect.left + value * trackRect.width) + 35, trackRect.center.dy);

    final Path path = Path()
      ..addArc(Rect.fromCenter(center: thumbCenter, width: 2 * radius, height: 2 * radius), 0, math.pi * 2);

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        _debugDrawShadow(canvas, path, evaluatedElevation);
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    }

    canvas.drawCircle(
      thumbCenter,
      radius,
      Paint()..color = Colors.white,
    );
  }

}

class CustomSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  @override
  void paint(
      PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool? isEnabled,
    bool? isDiscrete,
    required TextDirection textDirection,
  }) {
    //     final ColorTween activeTrackColorTween = ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    // final ColorTween inactiveTrackColorTween = ColorTween(begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 6.0
      ..shader = ui.Gradient.radial(
          Offset(parentBox.size.width / 2, thumbCenter.dx), // center
          500, // radius
          [Colors.orange, Colors.purple, Colors.blue], // colors
          [0, 0.5, 1.0],
        );
    final Paint inactivePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 6.0
      ..shader = ui.Gradient.radial(
          Offset(parentBox.size.width / 2, thumbCenter.dx), // center
          500, // radius
          [Colors.orange, Colors.purple, Colors.blue], // colors
          [0, 0.5, 1.0],
        );
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    print(thumbCenter);
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled!,
      isDiscrete: isDiscrete!,
    );
      final path = Path();
      path.moveTo(0, thumbCenter.dy);
    final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom);
    if (!leftTrackSegment.isEmpty) {
      // path.addRect(leftTrackSegment);
      path.lineTo(thumbCenter.dx, thumbCenter.dy);
      // context.canvas.drawRect(leftTrackSegment, leftTrackPaint);
      context.canvas.drawPath(path, leftTrackPaint);
    }
    var controlPoint = Offset(thumbCenter.dy, -80);
    // endpoint of the curve. Relative to the current position of the path
    var endPoint = Offset(70, offset.dy);
    path.relativeConicTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy, 0.7);

    final Rect rightTrackSegment = Rect.fromLTRB(thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom);
    if (!rightTrackSegment.isEmpty) {
      path.lineTo(trackRect.right, thumbCenter.dy);
      // path.lineTo(thumbCenter.dx, 0);
      context.canvas.drawPath(path, rightTrackPaint);
      // context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
    }

    final bool showSecondaryTrack = (secondaryOffset != null) &&
        ((textDirection == TextDirection.ltr)
            ? (secondaryOffset.dx > thumbCenter.dx)
            : (secondaryOffset.dx < thumbCenter.dx));

}
}
