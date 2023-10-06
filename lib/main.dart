import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animations/slider_paint.dart';

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CurvedSlider(width: 500, height: 50),
    );
  }
}

class CurvedSlider extends StatefulWidget {
  final double width;
  final double height;
  const CurvedSlider({super.key, required this.width, required this.height});

  @override
  State<CurvedSlider> createState() => _CurvedSliderState();
}

class _CurvedSliderState extends State<CurvedSlider> {
  double _currentDragPosition = 0;
  double _dragPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.flip(
        flipY: true,
        child: RotatedBox(
        quarterTurns: -1,
        child: GestureDetector(
                    onHorizontalDragUpdate: (details) =>
                        _onVerticalDragUpdate(context, details),
                    onHorizontalDragStart: (details) =>
                        _onVerticalDragStart(context, details),
                    onHorizontalDragEnd: (details) {
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.red.withOpacity(0.4),
                      width: widget.width,
                      height: widget.height,
                      child: CustomPaint(
                        painter: SliderPainter(
                          sliderPosition: _currentDragPosition,
                          dragPercentage: _dragPercentage,
                        ),
                      ),
                    ),
                  ),
      )
      ),
    );
  }

  _updateCurrentDragPosition(Offset offset) {
    double newPosition = 0;
    if (offset.dy <= 0.0) {
      newPosition = 0.0;
    } else if (offset.dy >= widget.width) {
      newPosition = widget.width;
    } else {
      newPosition = offset.dy;
    }

    setState(() {
      _currentDragPosition = newPosition;
      _dragPercentage = _currentDragPosition / widget.width;
    });
  }

  void _onVerticalDragUpdate(BuildContext context, DragUpdateDetails details) {
    RenderBox sliderBox = context.findRenderObject() as RenderBox;
    Offset offset = sliderBox.globalToLocal(details.globalPosition);
    _updateCurrentDragPosition(offset);
  }

  void _onVerticalDragStart(BuildContext context, DragStartDetails details) {
    RenderBox sliderBox = context.findRenderObject() as RenderBox;
    Offset offset = sliderBox.globalToLocal(details.globalPosition);
    _updateCurrentDragPosition(offset);
  }
}
