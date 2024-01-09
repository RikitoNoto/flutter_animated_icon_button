import 'package:flutter/material.dart';

/// A TapFillIcon is an icon button widget.
/// When this button tapped, it change the icon from [borderIcon] to [fillIcon] with animations.
/// If you push when this button's state is [fillIcon], change from [fillIcon] to [borderIcon] without animations.
/// The animations exist rotaion and scale.
///
///
/// {@tool snippet}
/// This example shows how to create a favorite button that is often used in SNS apps.
/// ```dart
/// TapFillIcon(
///   fillIcon: Icon(Icons.favorite, color: Colors.red),
///   borderIcon: Icon(Icons.favorite_border, color: Colors.grey),
///   initialPushed: false,
/// ),
/// ```
/// {@end-tool}
class TapFillIcon extends StatefulWidget {
  const TapFillIcon({
    required this.fillIcon,
    required this.borderIcon,
    this.animateDuration = const Duration(milliseconds: 300),
    this.initialPushed = false,
    this.animationController,
    this.animationCurve = Curves.easeOutBack,
    this.onTap,
    this.onPush,
    this.onPull,
    super.key,
  });

  /// An icon after pushed this button.
  final Widget fillIcon;

  /// An icon before pushed this button.
  final Widget borderIcon;

  /// The duration of the animation from tap to filled icon.
  final Duration animateDuration;

  /// The initial state of this button.
  final bool initialPushed;

  /// An animation controller of this button.
  final AnimationController? animationController;

  /// The animation curve when fill an icon.
  final Curve animationCurve;

  /// A callback when tap this button.
  final void Function()? onTap;

  /// A callback when tap this button from the state of [borderIcon].
  final void Function()? onPush;

  /// A callback when tap this button from the state of [fillIcon].
  final void Function()? onPull;

  @override
  TapFillIconState createState() => TapFillIconState();
}

class TapFillIconState extends State<TapFillIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPushed = false;

  @override
  void initState() {
    if (widget.animationController != null) {
      _controller = widget.animationController!;
    } else {
      _controller = AnimationController(
        vsync: this,
        duration: widget.animateDuration,
        lowerBound: 0.0,
        upperBound: 1.0,
      );
    }
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (widget.initialPushed) {
      _isPushed = true;
      _controller.value = _controller.upperBound;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        if (_isPushed) {
          widget.onPull?.call();
          _controller.value = _controller.lowerBound;
        } else {
          widget.onPush?.call();
          _controller.forward();
        }

        _isPushed = !_isPushed;
      },
      child: Stack(
        children: [
          widget.borderIcon,
          Transform.scale(
            scale: CurvedAnimation(
                    parent: _controller, curve: widget.animationCurve)
                .drive(Tween(
                    begin: _controller.lowerBound, end: _controller.upperBound))
                .value,
            child: widget.fillIcon,
          ),
        ],
      ),
    );
  }
}
