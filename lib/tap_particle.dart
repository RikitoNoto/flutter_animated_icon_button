import 'dart:math';
import 'package:flutter/material.dart';

/// A [TapParticle] display particles when push button.
/// If [syncAnimation] is set, display particles according to it.
///
///
/// {@tool snippet}
/// This example shows how to create the button that be able to display particle.
/// ```dart
///final controller = AnimationController(
/// vsync: this,
/// duration: Duration(milliseconds: 300),
/// lowerBound: 0.0,
/// upperBound: 1.0,
///);
///TapParticle(
/// size: 50,
/// particleCount: 5,
/// color: Colors.red,
/// syncAnimation: controller,
/// duration: const Duration(milliseconds: 500),
/// child: TapFillIcon(
///   animationController: controller,
///   borderIcon: const Icon(
///     Icons.star_border,
///     color: Colors.grey,
///     size: 50,
///   ),
///   fillIcon: const Icon(
///     Icons.star,
///     color: Colors.yellow,
///     size: 50,
///   ),
///   initialPushed: false,
///   ),
///),
/// ```
/// {@end-tool}
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

  /// The size of [child] in this object.
  /// It display empty space of the size.
  final double size;

  /// The widget in the center of a particle.
  final Widget? child;

  /// The Animation for synchronizing the particle animation.
  /// The particle animation is starting when [syncAnimation] called forward method.
  /// If [syncAnimation] called reverse method, the particle animation reset animation.
  final AnimationController? syncAnimation;

  /// The animation controller for controlling the particle animation.
  final AnimationController? controller;

  /// The animation's duration.
  final Duration duration;

  /// The number of particle lines.
  /// The particles display in a circle.
  final int particleCount;

  /// The maximum length of a particle.
  /// Particles are to this length when the animation value is just half.
  final double? particleLength;

  /// The color of particles.
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
          size: widget.size,
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
              lineLength: lineLength != null ? lineLength! : size * 0.3,
            ),
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
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5;

    final startY = size.height / 2 - size.height * animation.value;
    final endY = startY - lineLength * _lengthAnimation(animation.value);

    final start = Offset(size.width / 2, startY);
    final end = Offset(size.width / 2, endY);

    canvas.drawLine(start, end, paint);
  }

  /// This function convert from the value between 0.0 and 1.0 to the cubic function that return the value below.
  /// | animation | return value |
  /// | -- | -- |
  /// | 0.0 | 0.0 |
  /// | 0.5 | 1.0 |
  /// |1.0 | 0.0 |
  double _lengthAnimation(double animation) {
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
