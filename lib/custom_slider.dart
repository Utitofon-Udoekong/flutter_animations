import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_animations/base_slider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


class CustomSlider extends StatefulWidget {
  
  const CustomSlider({super.key, this.min, this.max, this.value, this.onChanged, this.onChangeStart, this.onChangeEnd});
  /// The minimum value that the user can select.
  ///
  /// Defaults to 0.0. Must be less than the [max].
  final dynamic min;

  /// The maximum value that the user can select.
  ///
  /// Defaults to 1.0. Must be greater than the [min].
  final dynamic max;
  /// The value currently selected in the slider.
  final dynamic value;

  /// Called when the user is selecting a new value for the slider by dragging.
  ///
  /// The slider passes the new value to the callback but
  /// does not change its state until the parent widget rebuilds
  /// the slider with new value.
  ///
  /// If it is null, the slider will be disabled.
  final ValueChanged<dynamic>? onChanged;

  /// The [onChangeStart] callback will be called when the user starts
  /// to tap or drag the slider. This callback is only used to notify
  /// the user about the start interaction and it does not update the
  /// slider value.
  ///
  /// The last interacted thumb value will be passed to this callback.
  final ValueChanged<dynamic>? onChangeStart;

  /// The [`onChangeEnd`] callback will be called when the user ends
  /// tap or drag the slider.
  ///
  /// This callback is only used to notify the user about the end interaction
  /// and it does not update the slider thumb value.
  final ValueChanged<dynamic>? onChangeEnd;

  @override
  State<CustomSlider> createState() => _CustomSliderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    // TODO: implement debugFillProperties
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>("value", value));
    properties.add(DiagnosticsProperty<dynamic>("min", min));
    properties.add(DiagnosticsProperty<dynamic>("max", max));
     properties.add(ObjectFlagProperty<ValueChanged<double>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
        'onChangeStart', onChangeStart));
    properties.add(ObjectFlagProperty<ValueChanged<dynamic>>.has(
        'onChangeEnd', onChangeEnd));
  }
}

class _CustomSliderState extends State<CustomSlider> with TickerProviderStateMixin {

  late AnimationController overlayController;
  late AnimationController stateController;
  final Duration duration = const Duration(milliseconds: 100);

  void _onChanged(dynamic value) {
    if (value != widget.value) {
      widget.onChanged!(value);
    }
  }

  void _onChangeStart(dynamic value) {
    if (widget.onChangeStart != null) {
      widget.onChangeStart!(value);
    }
  }

  void _onChangeEnd(dynamic value) {
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd!(value);
    }
  }

  String _getFormattedLabelText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  String _getFormattedTooltipText(dynamic actualText, String formattedText) {
    return formattedText;
  }

  @override
  void initState() {
    super.initState();
    overlayController = AnimationController(vsync: this, duration: duration);
    stateController = AnimationController(vsync: this, duration: duration);
    stateController.value =
        widget.onChanged != null && (widget.min != widget.max) ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    overlayController.dispose();
    stateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive =
        widget.onChanged != null && (widget.min != widget.max);
    final ThemeData themeData = Theme.of(context);
    return const Placeholder();
  }
}

class _SliderRenderObjectWidget extends RenderObjectWidget{

  const _SliderRenderObjectWidget(this.min, this.max, this.value, this.onChanged, this.onChangeStart, this.onChangeEnd, this.state, {super.key});
  final dynamic min;
  final dynamic max;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;
  final ValueChanged<dynamic>? onChangeStart;
  final ValueChanged<dynamic>? onChangeEnd;
  final _CustomSliderState state;


  @override
  RenderObjectElement createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }

}

class _RenderSlider extends BaseSlider implements MouseTrackerAnnotation {
  _RenderSlider({
    required dynamic min,
    required dynamic max,
    required dynamic value,
    required ValueChanged<dynamic>? onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
    required MediaQueryData mediaQueryData,
    required _CustomSliderState state,
    required DeviceGestureSettings gestureSettings,
  })  : _state = state,
        _value = value,
        _onChanged = onChanged,
        super(
          min: min,
          max: max,
          mediaQueryData: mediaQueryData,
        ) {
    final GestureArenaTeam team = GestureArenaTeam();
      verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
        ..team = team
        ..onStart = _onVerticalDragStart
        ..onUpdate = _onVerticalDragUpdate
        ..onEnd = _onVerticalDragEnd
        ..onCancel = _onVerticalDragCancel
        ..gestureSettings = gestureSettings;
   

    tapGestureRecognizer = TapGestureRecognizer()
      ..team = team
      ..onTapDown = _onTapDown
      ..onTapUp = _onTapUp;

    _overlayAnimation = CurvedAnimation(
        parent: _state.overlayController, curve: Curves.fastOutSlowIn);

    _stateAnimation = CurvedAnimation(
        parent: _state.stateController, curve: Curves.easeInOut);

  }

  final _CustomSliderState _state;

  late Animation<double> _overlayAnimation;

  late Animation<double> _stateAnimation;

  late bool _validForMouseTracker;

  late dynamic _newValue;

  ValueChanged<dynamic>? onChangeStart;

  ValueChanged<dynamic>? onChangeEnd;

  double? _valueInMilliseconds;


  dynamic get value => _value;
  dynamic _value;

  set value(dynamic value) {
    if (_value == value) {
      return;
    }

    _value = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  ValueChanged<dynamic>? get onChanged => _onChanged;
  ValueChanged<dynamic>? _onChanged;

  set onChanged(ValueChanged<dynamic>? value) {
    if (value == _onChanged) {
      return;
    }
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      if (isInteractive) {
        _state.stateController.forward();
      } else {
        _state.stateController.reverse();
      }
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  @override
  bool get isInteractive => onChanged != null;

  double get actualValue =>
      // ignore: avoid_as
      _value.toDouble();

  dynamic get _increasedValue {
    return getNextSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
  }

  dynamic get _decreasedValue {
    return getPrevSemanticValue(value, semanticActionUnit,
        actualValue: actualValue);
  }

  void _onTapDown(TapDownDetails details) {
    currentPointerType = PointerType.down;
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _beginInteraction();
  }

  void _onTapUp(TapUpDetails details) {
    _endInteraction();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _beginInteraction();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    isInteractionEnd = false;
    currentPointerType = PointerType.move;
    mainAxisOffset = globalToLocal(details.globalPosition).dy;
    _updateValue();
    markNeedsPaint();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _onVerticalDragCancel() {
    _endInteraction();
  }

  void _beginInteraction() {
    isInteractionEnd = false;
    onChangeStart?.call(_value);
    _state.overlayController.forward();
    _updateValue();
    markNeedsPaint();
  }

  void _updateValue() {
    final double factor = getFactorFromCurrentPosition();
    final double valueFactor = lerpDouble(actualMin, actualMax, factor)!;
    _newValue = getActualValue(valueInDouble: valueFactor);

    if (_newValue != _value) {
      onChanged!(_newValue);
    }
  }

  void _endInteraction() {
    if (!isInteractionEnd) {
      _state.overlayController.reverse();
      currentPointerType = PointerType.up;
      isInteractionEnd = true;
      onChangeEnd?.call(_newValue);
      markNeedsPaint();
    }
  }

  void increaseAction() {
    if (isInteractive) {
      onChanged!(_increasedValue);
    }
  }

  void decreaseAction() {
    if (isInteractive) {
      onChanged!(_decreasedValue);
    }
  }

  void _handleEnter(PointerEnterEvent event) {
    _state.overlayController.forward();
  }

  void _handleExit(PointerExitEvent event) {
    // Ensuring whether the thumb is drag or move
    // not needed to call controller's reverse.
    if (_state.mounted && currentPointerType != PointerType.move) {
      _state.overlayController.reverse();
     
    }
  }


  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
    _overlayAnimation.addListener(markNeedsPaint);
    _stateAnimation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    _overlayAnimation.removeListener(markNeedsPaint);
    _stateAnimation.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void dispose() {
    verticalDragGestureRecognizer?.dispose();
    tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener get onEnter => _handleEnter;

  @override
  PointerExitEventListener get onExit => _handleExit;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position) && isInteractive) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Offset actualTrackOffset = Offset(
            offset.dx +
                (size.width - actualHeight) / 2 +
                trackOffset.dx -
                maxTrackHeight / 2,
            offset.dy);

    // Drawing track.
    final Rect trackRect =
        trackShape.getPreferredRect(this, sliderThemeData, actualTrackOffset);
    final double thumbPosition = getFactorFromValue(actualValue) * trackRect.height;
    final Offset thumbCenter = Offset(trackRect.center.dx, trackRect.bottom - thumbPosition);

    trackShape.paint(context, actualTrackOffset, thumbCenter, null, null,
        parentBox: this,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: TextDirection.ltr,
        activePaint: null,
        inactivePaint: null);

    // // Drawing overlay.
    // overlayShape.paint(context, thumbCenter,
    //     parentBox: this,
    //     currentValue: _value,
    //     themeData: sliderThemeData,
    //     animation: _overlayAnimation,
    //     thumb: null,
    //     paint: null);

   
    // Drawing thumb.
    thumbShape.paint(context, thumbCenter,
        parentBox: this,
        child: _thumbIcon,
        currentValue: _value,
        themeData: sliderThemeData,
        enableAnimation: _stateAnimation,
        textDirection: textDirection,
        thumb: null,
        paint: null);

  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = isInteractive;
    if (isInteractive) {
      config.onIncrease = increaseAction;
      config.onDecrease = decreaseAction;
      config.value = '$value';
        config.increasedValue = '$_increasedValue';
        config.decreasedValue = '$_decreasedValue';
    }
  }

}