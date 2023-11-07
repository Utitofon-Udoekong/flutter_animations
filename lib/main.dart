import 'package:flutter/material.dart';
import 'package:flutter_animations/slider.dart';
import 'package:flutter_animations/xslider/slider.dart';

void main() => runApp( MaterialApp(
      home: const App(),
      theme: ThemeData(
        useMaterial3: true,
      ),
    ));

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _age = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Container(
            color: Colors.red.withOpacity(0.4),
            child: XSlider(
              sliderWidth: 50,
              sliderHeight: 500,
              onChanged: (double val) {
                // setState(() {
                //   _age = (val * 100).round();
                // });
              },
              onChangeStart: (double val){},
              onChangeEnd: (double val){},
              screenHeight: size.height,
            ),
          ),
        ),
      ),
    );
  }
}
