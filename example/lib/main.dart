import 'package:flutter/material.dart';

void main() {
  runApp(TapIconApp());
}

class TapIconApp extends StatelessWidget {
  const TapIconApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TapIconAnimation(),
    );
  }
}

class TapIconAnimation extends StatefulWidget {
  const TapIconAnimation({super.key});
  static const icon = Icons.favorite;
  @override
  _TapIconAnimationState createState() => _TapIconAnimationState();
}

class NormalDistributionCurve extends Curve {
  const NormalDistributionCurve([this.period = 0.4]);

  /// The duration of the oscillation.
  final double period;

  @override
  double transformInternal(double t) {
    // return -4 * (t - 0.5) * (t - 0.5) + 1;
    print('t: $t\t v: ${4 * (-t * t + t)}');
    return 4 * (-t * t + t);
  }

  @override
  String toString() {
    return 'NormalDistributionCurve';
  }
}

class _TapIconAnimationState extends State<TapIconAnimation>
    with SingleTickerProviderStateMixin {
  bool _showFirstIcon = true;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    this._controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  void _toggleIcon() {
    if (_controller.value == 0.0) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Icon Animation')),
      body: Center(
        child: GestureDetector(
            onTap: _toggleIcon,
            child: Stack(
              children: [
                Icon(
                  Icons.favorite_border,
                  color: Colors.grey,
                ),
                Transform.scale(
                  scale: CurvedAnimation(
                          parent: _controller, curve: Curves.easeOutBack)
                      .drive(Tween<double>(begin: 0, end: 1))
                      .value,
                  child: Icon(Icons.favorite, color: Colors.red),
                ),
                CustomPaint(
                  size: Size(200, 200),
                  painter: TapParticlePainter(
                      sizeAnimation: CurvedAnimation(
                              parent: _controller,
                              curve: NormalDistributionCurve())
                          .drive<double>(Tween<double>(begin: 0, end: 1)),
                      positionAnimation: CurvedAnimation(
                              parent: _controller, curve: Curves.easeOutBack)
                          .drive(Tween<double>(begin: 0, end: 1))),
                ),
              ],
            )
            // AnimatedContainer(
            //   duration: const Duration(seconds: 1),
            //   child: _showFirstIcon
            //       // ? const Icon(Icons.star, key: ValueKey<int>(1))
            //       // : const Icon(Icons.favorite, key: ValueKey<int>(2)),
            //       ? Icon(Icons.favorite, size: 100.0, color: Colors.red)
            //       : Icon(Icons.favorite, size: 50.0, color: Colors.red),
            //   // transitionBuilder: (child, animation) {
            //   //   return ScaleTransition(
            //   //     scale: animation,
            //   //     child: RotationTransition(
            //   //       turns: animation,
            //   //       child: child,
            //   //     ),
            //   //   );
            //   // },
            // ),
            ),
      ),
    );
  }
}

class TapParticlePainter extends CustomPainter {
  Animation<double> sizeAnimation;
  Animation<double> positionAnimation;

  TapParticlePainter(
      {required this.sizeAnimation, required this.positionAnimation})
      : super(repaint: sizeAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    double startY = size.height * (1 - sizeAnimation.value);
    double endY = size.height * (1 - positionAnimation.value);

    Offset start = Offset(size.width / 2, startY);
    Offset end = Offset(size.width / 2, endY);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

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
