import 'package:flutter/material.dart';
import 'package:flutter_animated_icon_button/animate_change_icon.dart';
import 'package:flutter_animated_icon_button/tap_fill_icon.dart';
import 'package:flutter_animated_icon_button/tap_particle.dart';

void main() {
  runApp(const IconSampleApp());
}

class IconSampleApp extends StatefulWidget {
  const IconSampleApp({super.key});

  @override
  IconSampleAppState createState() => IconSampleAppState();
}

class IconSampleAppState extends State<IconSampleApp>
    with TickerProviderStateMixin {
  late AnimationController _favoriteController;
  late AnimationController _starController;

  @override
  void initState() {
    _favoriteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _favoriteController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _starController.addListener(() {
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
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tap fill favorite button',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TapFillIcon(
                animationController: _favoriteController,
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
              const SizedBox(
                height: 50,
              ),
              Text(
                'Tap fill start button with particle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TapParticle(
                size: 50,
                particleCount: 5,
                particleLength: 10,
                color: Colors.yellow,
                syncAnimation: _starController,
                duration: const Duration(milliseconds: 300),
                child: TapFillIcon(
                  animationController: _starController,
                  borderIcon: const Icon(
                    Icons.star_border,
                    color: Colors.grey,
                    size: 50,
                  ),
                  fillIcon: const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 50,
                  ),
                  initialPushed: false,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Tap change with animation button',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const AnimateChangeIcon(
                animateDuration: Duration(milliseconds: 300),
                firstIcon: Icon(
                  Icons.play_arrow_rounded,
                  size: 50,
                ),
                secondIcon: Icon(
                  Icons.stop_rounded,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
