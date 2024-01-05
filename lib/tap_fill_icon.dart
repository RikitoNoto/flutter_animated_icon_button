import 'package:flutter/material.dart';

class TapFillIcon extends StatefulWidget {
  const TapFillIcon({
    required this.fillIcon,
    required this.borderIcon,
    this.fillColor = Colors.black,
    this.borderColor = Colors.grey,
    this.animateDuration = const Duration(milliseconds: 300),
    this.initialPushed = false,
    this.animationController,
    this.animationCurve = Curves.easeOutBack,
    this.size,
    this.onTap,
    this.onPush,
    this.onPull,
    super.key,
  });
  static const icon = Icons.favorite;

  final IconData fillIcon;
  final IconData borderIcon;
  final Color fillColor;
  final Color borderColor;
  final Duration animateDuration;
  final bool initialPushed;
  final AnimationController? animationController;
  final Curve animationCurve;
  final double? size;
  final void Function()? onTap;
  final void Function()? onPush;
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
          Icon(
            widget.borderIcon,
            size: widget.size,
            color: widget.borderColor,
          ),
          Transform.scale(
            scale: CurvedAnimation(
                    parent: _controller, curve: widget.animationCurve)
                .drive(Tween(
                    begin: _controller.lowerBound, end: _controller.upperBound))
                .value,
            child: Icon(widget.fillIcon,
                size: widget.size, color: widget.fillColor),
          ),
        ],
      ),
    );
  }
}
