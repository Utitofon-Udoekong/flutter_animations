import 'package:flutter/material.dart';

class CSlider extends StatelessWidget {
  const CSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0.0,
            child: Container(
              height: 300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -10),
                  blurRadius: 3,
                  spreadRadius: 10,
                )
              ]),
        )),
        Positioned(
          bottom: 0.0,
            child: Container(
              height: 250,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -10),
                  blurRadius: 3,
                  spreadRadius: 10,
                )
              ]),
        ))
      ],
    );
  }
}
