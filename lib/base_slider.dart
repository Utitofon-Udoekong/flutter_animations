import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

enum PointerType { down, move, up }

class BaseSlider extends RenderProxyBox with RelayoutWhenSystemFontsChangeMixin {
BaseSlider({
    required dynamic min,
    required dynamic max,
    required MediaQueryData mediaQueryData,
  })  : _min = min,
        _max = max,
        _trackShape = const SfTrackShape(),
        _thumbShape = const SfThumbShape(),
        _mediaQueryData = mediaQueryData,
        _sliderThemeData = SfSliderThemeData();
  final double minTrackWidth = kMinInteractiveDimension * 3;

  bool isInactive = false;

  //ignore: prefer_final_fields
  bool isInteractionEnd = true;

  VerticalDragGestureRecognizer? verticalDragGestureRecognizer;

  late TapGestureRecognizer tapGestureRecognizer;

  late double actualHeight;

  late Offset trackOffset;

  late double maxTrackHeight;

  // It stores the current touch x-position, which is used in
  // the [endInteraction] and [dragUpdate] method.
  //ignore: prefer_final_fields
  double mainAxisOffset = 0.0;

  PointerType? currentPointerType;

  dynamic get min => _min;
  dynamic _min;
  set min(dynamic value) {
    if (_min == value) {
      return;
    }
    _min = value;
    markNeedsPaint();
  }

  dynamic get max => _max;
  dynamic _max;
  set max(dynamic value) {
    if (_max == value) {
      return;
    }
    _max = value;
    markNeedsPaint();
  }


  SfTrackShape get trackShape => _trackShape;
  SfTrackShape _trackShape;
  set trackShape(SfTrackShape value) {
    if (_trackShape == value) {
      return;
    }
    _trackShape = value;
    markNeedsLayout();
  }

  SfSliderThemeData get sliderThemeData => _sliderThemeData;
  SfSliderThemeData _sliderThemeData;
  set sliderThemeData(SfSliderThemeData value) {
    if (_sliderThemeData == value) {
      return;
    }
    _sliderThemeData = value;
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData == value) {
      return;
    }
    _mediaQueryData = value;
    markNeedsLayout();
  }

  bool get isInteractive => false;

  // ignore: avoid_as
  double get actualMin => _min.toDouble() as double;

  // ignore: avoid_as
  double get actualMax =>
       _max.toDouble() as double;

  Rect get actualTrackRect =>
      _trackShape.getPreferredRect(this, _sliderThemeData, Offset.zero);

  double get adjustmentUnit => (actualMax - actualMin) / 10;

  double getFactorFromValue(dynamic value) {
    // If min and max are equal, the result will be NAN. This creates exception
    // and widget will not rendered.
    // So we have checked a condition (actualMax <= actualMin).
    final double factor = (value == null || actualMax <= actualMin)
        ? 0.0
        // ignore: avoid_as
        : (value - actualMin) / (actualMax - actualMin) as double;
      return factor;
  }

  double getPositionFromValue(double value) {
    return getFactorFromValue(value);
  }

  double getFactorFromCurrentPosition() {
    final double factor = ((actualTrackRect.bottom - mainAxisOffset) / actualTrackRect.height)
            .clamp(0.0, 1.0);
      return factor;
  }

  dynamic getActualValue({dynamic value, double? valueInDouble}) {
    return value ?? valueInDouble;
  }

  double getValueFromFactor(double factor) {
    return factor * (actualMax - actualMin) + actualMin;
  }

  double getNumerizedValue(dynamic value) {
    // ignore: avoid_as
    return value.toDouble() as double;
  }

  dynamic get semanticActionUnit => adjustmentUnit;

  dynamic getNextSemanticValue(dynamic value, dynamic semanticActionUnit,
      {required double actualValue}) {
      return (value + semanticActionUnit).clamp(_min, _max);
  }

  dynamic getPrevSemanticValue(dynamic value, dynamic semanticActionUnit,
      {required double actualValue}) {
      return (value - semanticActionUnit).clamp(_min, _max);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    }
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    // Checked [_isInteractionEnd] for avoiding multi touch.
    if (isInteractionEnd && event.down && event is PointerDownEvent) {
        verticalDragGestureRecognizer!.addPointer(event);
      tapGestureRecognizer.addPointer(event);
    }
  }
}
