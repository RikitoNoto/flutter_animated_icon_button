import 'package:flutter/material.dart';
import 'package:flutter_animated_icon_button/animate_change_icon.dart';
import 'package:flutter_animated_icon_button/tap_fill_icon.dart';
import 'package:flutter_animated_icon_button/tap_particle.dart';

void main() {
  runApp(const IconApp());
}

class IconApp extends StatefulWidget {
  const IconApp({super.key});

  @override
  IconAppState createState() => IconAppState();
}

class IconAppState extends State<IconApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Icon animations'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TapParticle(
              size: 50,
              syncAnimation: _controller,
              duration: const Duration(milliseconds: 500),
              child: TapFillIcon(
                animationController: _controller,
                borderIcon: const Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                  size: 50,
                ),
                fillIcon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 50,
                ),
                initialPushed: false,
              ),
            ),
          ),
          AnimateChangeIcon(
            animateDuration: Duration(milliseconds: 300),
            firstIcon: Icon(Icons.play_arrow),
            secondIcon: Icon(Icons.stop),
          ),
        ],
      ),
    ));
  }
}
