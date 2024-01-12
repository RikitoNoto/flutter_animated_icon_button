# flutter_animated_icon_button
An animated icon plugin.
This plugin allows you to create an animated icon button easily.
<img width="100%" src="https://raw.githubusercontent.com/RikitoNoto/flutter_animated_icon_button/master/doc/assets/animate_icon_push.gif">


## Getting Started
To use this plugin, add ```flutter_animated_icon_button``` to a dependency in your ```pubspec.yaml```.
```yaml
flutter_animated_icon_button: ^1.0.0
```

## Example
## TapFillIcon
The code below shows how to create the Good icon button that is often used in SNS apps.
```dart
TapFillIcon(
    borderIcon: const Icon(
      Icons.favorite_border,
      color: Colors.grey,
    ),
    fillIcon: const Icon(
      Icons.favorite,
      color: Colors.red,
    ),
),
```

This code builds the below icon button.

<img width="50%" src="https://raw.githubusercontent.com/RikitoNoto/flutter_animated_icon_button/master/doc/assets/animate_icon_favorite.gif">


## TapFillIconWithParticle
The code below shows how to create the Favorite icon button with particles.
```dart
// Please initialize a controller in 'initState' of the class that mixin TickerProviderStateMixin

  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TapParticle(
      size: 50,
      particleCount: 5,
      particleLength: 10,
      color: Colors.orange,
      syncAnimation: controller,
      duration: const Duration(milliseconds: 300),
      child: TapFillIcon(
        animationController: controller,
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
      ),
    ),
  }
```

This code builds the below icon button.

<img width="50%" src="https://raw.githubusercontent.com/RikitoNoto/flutter_animated_icon_button/master/doc/assets/animate_icon_star.gif">


## AnimateChangeIcon
The code below shows how to create the icon button that can change its icon from Play to Stop with animation.
```dart
AnimateChangeIcon(
  firstIcon: Icon(
    Icons.play_arrow_rounded,
  ),
  secondIcon: Icon(
    Icons.stop_rounded,
  ),
),
```

This code builds the below icon button.

<img width="50%" src="https://raw.githubusercontent.com/RikitoNoto/flutter_animated_icon_button/master/doc/assets/animate_icon_play_stop.gif">
