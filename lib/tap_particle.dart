import 'dart:math';

import 'package:flutter/material.dart';

class TapParticle extends StatefulWidget {
  const TapParticle({
    this.size = 300,
    this.child,
    super.key,
  });

  final double size;
  final Widget? child;

  @override
  TapParticleState createState() => TapParticleState();
}

class TapParticleState extends State<TapParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) ...[
          widget.child!,
        ],
        Container(
          height: 50,
          width: 50,
          color: Colors.red,
        ),
        CircleParticle(animation: _controller),
      ],
    );
  }
}

class CircleParticle extends StatelessWidget {
  const CircleParticle({
    required this.animation,
    this.lineCount = 8,
    this.size = 50,
    super.key,
  });
  final Animation<double> animation;
  final int lineCount;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        lineCount,
        (i) => Transform.rotate(
          angle: 2 * pi / lineCount * i,
          child: CustomPaint(
            size: Size(size, size),
            painter: LineParticlePainter(
                animation: animation, lineLength: size * 0.6),
          ),
        ),
      ),
    );
  }
}

class LineParticlePainter extends CustomPainter {
  LineParticlePainter({
    required this.animation,
    required this.lineLength,
  }) : super(repaint: animation);
  final Animation<double> animation;
  final double lineLength;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 5;

    // double startY = size.height * (1 - animation.value);
    double startY = size.height * animation.value + size.height / 2;
    double endY = startY + lineLength * lengthAnimation(animation.value);

    Offset start = Offset(size.width / 2, startY);
    Offset end = Offset(size.width / 2, endY);

    canvas.drawLine(start, end, paint);
  }

  double lengthAnimation(double animation) {
    var value = -15.8730158730158 * pow(animation, 3) +
        22.222222222222 * pow(animation, 2) +
        -6.34920634920 * animation;
    if (value < 0) {
      value = 0;
    }
    return value;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
