import 'package:flutter/material.dart';

class FadeIconApp extends StatelessWidget {
  const FadeIconApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IconAnimation(),
    );
  }
}

class IconAnimation extends StatefulWidget {
  const IconAnimation({super.key});

  @override
  _IconAnimationState createState() => _IconAnimationState();
}

class _IconAnimationState extends State<IconAnimation> {
  bool _showFirstIcon = true;

  void _toggleIcon() {
    setState(() {
      _showFirstIcon = !_showFirstIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Icon Animation')),
      body: Center(
        child: GestureDetector(
          onTap: _toggleIcon,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: _showFirstIcon
                ? const Icon(Icons.star, key: ValueKey<int>(1))
                : const Icon(Icons.favorite, key: ValueKey<int>(2)),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: RotationTransition(
                  turns: animation,
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AnimatedBulbApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedBulb(),
    );
  }
}

class AnimatedBulb extends StatefulWidget {
  @override
  _AnimatedBulbState createState() => _AnimatedBulbState();
}

class _AnimatedBulbState extends State<AnimatedBulb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Bulb')),
      body: Center(
        child: CustomPaint(
          size: Size(200, 200),
          painter: BulbPainter(_controller),
        ),
      ),
    );
  }
}

class BulbPainter extends CustomPainter {
  Animation<double> animation;

  BulbPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    double startY = size.height * (1 - animation.value);
    double endY = size.height;

    Offset start = Offset(size.width / 2, startY);
    Offset end = Offset(size.width / 2, endY);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
