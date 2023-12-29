import 'dart:math';

import 'package:flutter/material.dart';

class AnimateChangeIcon extends StatefulWidget {
  const AnimateChangeIcon({
    required this.firstIcon,
    required this.secondIcon,
    this.animateDuration = const Duration(milliseconds: 500),
    this.initialPushed = false,
    this.animationController,
    this.scaleAnimationCurve = Curves.easeOutBack,
    this.rotateAnimationCurve = Curves.linear,
    this.rotateBeginAngle = -pi,
    this.rotateEndAngle = 0.0,
    this.onTap,
    super.key,
  });
  static const icon = Icons.favorite;

  final Icon firstIcon;
  final Icon secondIcon;
  final Duration animateDuration;
  final bool initialPushed;
  final AnimationController? animationController;
  final Curve scaleAnimationCurve;
  final Curve rotateAnimationCurve;
  final void Function()? onTap;
  final double rotateBeginAngle;
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
