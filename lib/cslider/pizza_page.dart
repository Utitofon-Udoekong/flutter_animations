import 'dart:ui';
import 'package:flutter/material.dart';

class PizzaPage extends StatefulWidget {
  const PizzaPage({super.key});

  @override
  State<PizzaPage> createState() => _PizzaPageState();
}

class _PizzaPageState extends State<PizzaPage> with TickerProviderStateMixin {
  late AnimationController _pizzaStateAnimationController;
  late AnimationController _toppingAnimationController;
  late AnimationController _pizzaSizeAnimationController;
  late Path _path;

  late Animation<double> pizzaSizeAnimation;
  late Animation<double> toppingAnimation;
  late Animation<double> pizzaStateAnimation;

  // Number of pizzas in cart
  int pizzaCount = 0;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    _pizzaStateAnimationController.dispose();
    _toppingAnimationController.dispose();
    _pizzaSizeAnimationController.dispose();
    super.dispose();
  }

  Path drawPath(Size size){
    // Size size = Size(300,300);
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height / 2);
    return path;
  }


  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
      ]
    );
  }
}

enum SliderState {
  SLIDING,
  DONE,
} 