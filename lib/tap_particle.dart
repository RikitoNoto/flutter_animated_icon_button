import 'dart:math';

import 'package:flutter/material.dart';

class TapParticle extends StatefulWidget {
  const TapParticle({
    this.size = 50,
    this.child,
    this.syncAnimation,
    this.controller,
    this.particleCount = 8,
    this.duration = const Duration(milliseconds: 500),
    this.particleLength,
    this.color = Colors.yellow,
    super.key,
  }) : assert(!(syncAnimation != null && controller != null), "");

  final double size;
  final Widget? child;
  final AnimationController? syncAnimation;
  final AnimationController? controller;
  final Duration duration;
  final int particleCount;
  final double? particleLength;
  final Color color;

  @override
  TapParticleState createState() => TapParticleState();
}

class TapParticleState extends State<TapParticle>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller != null
        ? widget.controller!
        : AnimationController(vsync: this, duration: widget.duration);
    final syncAnimation = widget.syncAnimation;
    if (syncAnimation != null) {
      syncAnimation.addListener(() {
        if (syncAnimation.status == AnimationStatus.forward) {
          final startTrriger =
              (syncAnimation.upperBound - syncAnimation.lowerBound) * 0.0;
          if (syncAnimation.upperBound > syncAnimation.lowerBound &&
              syncAnimation.value > startTrriger) {
            _controller.forward();
          }
          if (syncAnimation.upperBound < syncAnimation.lowerBound &&
              syncAnimation.value < startTrriger) {
            _controller.forward();
          }
        } else if (syncAnimation.value == syncAnimation.lowerBound) {
          _controller.value = _controller.lowerBound;
        }
      });
    }
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
        CircleParticle(
          animation: _controller,
          lineCount: widget.particleCount,
          lineLength: widget.particleLength,
          color: widget.color,
        ),
        if (widget.child != null) ...[
          widget.child!,
        ],
      ],
    );
  }
}

class CircleParticle extends StatelessWidget {
  const CircleParticle({
    required this.animation,
    required this.color,
    this.lineCount = 8,
    this.size = 50,
    this.lineLength,
    super.key,
  });
  final Animation<double> animation;
  final int lineCount;
  final double size;
  final double? lineLength;
  final Color color;

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
                animation: animation,
                color: color,
                lineLength: lineLength != null ? lineLength! : size * 0.3),
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
    required this.color,
  }) : super(repaint: animation);
  final Animation<double> animation;
  final double lineLength;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
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
