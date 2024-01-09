import 'dart:math';

import 'package:flutter/material.dart';

/// A [AnimateChangeIcon] is an icon button widget.
/// When this button tapped, it change the icon from [firstIcon] to [secondIcon] with animations.
/// The animations exist rotaion and scale.
///
///
/// {@tool snippet}
/// This example shows how to create the button being able to change icons from a play button to a stop button.
/// ```dart
/// AnimateChangeIcon(
///   firstIcon: Icon(
///     Icons.play_arrow_rounded,
///     size: 50,
///   ),
///   secondIcon: Icon(
///     Icons.stop_rounded,
///     size: 50,
///   ),
/// ),
/// ```
/// {@end-tool}
class AnimateChangeIcon extends StatefulWidget {
  const AnimateChangeIcon({
    required this.firstIcon,
    required this.secondIcon,
    this.animateDuration = const Duration(milliseconds: 300),
    this.initialPushed = false,
    this.animationController,
    this.scaleAnimationCurve = Curves.linear,
    this.rotateAnimationCurve = Curves.linear,
    this.rotateBeginAngle = -pi / 2,
    this.rotateEndAngle = 0.0,
    this.onTap,
    super.key,
  });

  /// An icon for show first and after [AnimateChangeIcon] was pushed odd time.
  /// If [initialPushed] is true, this icon display after [AnimateChangeIcon] was pushed even time.
  final Icon firstIcon;

  /// An icon display after [AnimateChangeIcon] was pushed odd time.
  /// If [initialPushed] is true, this icon display after [AnimateChangeIcon] was pushed odd time or first.
  final Icon secondIcon;

  /// An animation's duration.
  final Duration animateDuration;

  /// The flg for decide the state of first.
  final bool initialPushed;

  /// The controller for the animation of this button.
  /// This controller control the animation of scale and rotate.
  final AnimationController? animationController;

  /// The animation of this button for scale.
  final Curve scaleAnimationCurve;

  /// The animation of this button for rotate.
  final Curve rotateAnimationCurve;

  /// The callback function when on tap.
  final void Function()? onTap;

  /// A first angle of a rotate animation.
  /// A default value is -90 degree.
  final double rotateBeginAngle;

  /// A final angle of a rotate animation.
  /// A default value is 0 degree.
  final double rotateEndAngle;

  @override
  AnimateChangeIconState createState() => AnimateChangeIconState();
}

class AnimateChangeIconState extends State<AnimateChangeIcon>
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
          _controller.reverse();
        } else {
          _controller.forward();
        }

        _isPushed = !_isPushed;
      },
      child: Stack(
        children: [
          Transform.scale(
            scale: CurvedAnimation(
                    parent: _controller, curve: widget.scaleAnimationCurve)
                .drive(Tween(
                  begin: _controller.lowerBound,
                  end: _controller.upperBound,
                ))
                .value,
            child: Transform.rotate(
              angle: CurvedAnimation(
                      parent: _controller, curve: widget.rotateAnimationCurve)
                  .drive(Tween(
                    begin: _controller.upperBound * widget.rotateBeginAngle,
                    end: widget.rotateEndAngle,
                  ))
                  .value,
              child: widget.firstIcon,
            ),
          ),
          Transform.scale(
            scale: CurvedAnimation(
                    parent: _controller, curve: widget.scaleAnimationCurve)
                .drive(Tween(
                  begin: _controller.upperBound,
                  end: _controller.lowerBound,
                ))
                .value,
            child: Transform.rotate(
              angle: CurvedAnimation(
                      parent: _controller, curve: widget.rotateAnimationCurve)
                  .drive(Tween(
                    begin: widget.rotateEndAngle,
                    end: _controller.upperBound * widget.rotateBeginAngle,
                  ))
                  .value,
              child: widget.secondIcon,
            ),
          ),
        ],
      ),
    );
  }
}
