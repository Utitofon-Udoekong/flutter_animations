import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animations/xslider/paint.dart';

class XSlider extends StatefulWidget {
  final double sliderWidth;
  final double sliderHeight;
  final double screenHeight;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  const XSlider({super.key, required this.sliderWidth, required this.sliderHeight, required this.onChanged, required this.onChangeStart, required this.onChangeEnd, required this.screenHeight});

  @override
  State<XSlider> createState() => _XSliderState();
}

class _XSliderState extends State<XSlider> with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  double _dragPercentage = 0.0;
   WaveSliderController? _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = WaveSliderController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _slideController!.dispose();
  }

  _handleChanged(double val) {
    widget.onChanged(val);
  }

  _handleChangeStart(double val) {
    widget.onChangeStart(val);
  }

  _handleChangeEnd(double val) {
    widget.onChangeEnd(val);
  }

  void _updateDragPosition(Offset val) {
    double newDragPosition = 0.0;
    if (val.dy <= 0.0) {
      newDragPosition = 0.0;
    } else if (val.dy >= widget.sliderHeight) {
      newDragPosition = widget.sliderHeight;
    } else {
      newDragPosition = (val.dy / widget.screenHeight) * 500;
    }

    setState(() {
      _dragPosition = newDragPosition;
      _dragPercentage = _dragPosition / widget.sliderHeight;
    });
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localOffset = box.globalToLocal(start.globalPosition);
    _slideController!.setStateToStart();
    _updateDragPosition(localOffset);
    _handleChangeStart(_dragPercentage);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localOffset = box.globalToLocal(update.globalPosition);
    _slideController!.setStateToSliding();
    _updateDragPosition(localOffset);
    _handleChanged(_dragPercentage);
    print(_dragPercentage);
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    _slideController!.setStateToStopping();
    setState(() {});
    _handleChangeEnd(_dragPercentage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      child: CustomPaint(
        painter: XSliderPaint(
          sliderPosition: _dragPosition,
          dragPercentage: _dragPercentage,
          animationProgress: _slideController!.progress, wavePainter: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..shader = ui.Gradient.radial(
            Offset(size.width / 2, size.height/2), // center
            500, // radius
            [Colors.orange, Colors.purple, Colors.blue], // colors
            [0, 0.5, 1.0],
          ),
        ),
        size: const Size(50, 500),
      ),
    );
  }
}

class WaveSliderController extends ChangeNotifier {
  final AnimationController controller;
  SliderState _state = SliderState.resting;

  WaveSliderController({required TickerProvider vsync})
      : controller = AnimationController(vsync: vsync) {
    controller
      ..addListener(_onProgressUpdate)
      ..addStatusListener(_onStatusUpdate);
  }

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionCompleted();
    }
  }

  void _onTransitionCompleted() {
    if (_state == SliderState.stopping) {
      setStateToResting();
    }
  }

  double get progress => controller.value;

  SliderState get state => _state;

  void _startAnimation() {
    controller.duration = Duration(milliseconds: 500);
    controller.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToStart() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateToStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }

  void setStateToSliding() {
    _state = SliderState.sliding;
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }
}

enum SliderState {
  starting,
  resting,
  sliding,
  stopping,
}