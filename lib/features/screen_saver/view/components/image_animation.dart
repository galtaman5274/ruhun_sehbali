import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageAnimation extends StatefulWidget {
  final Widget image;
  const ImageAnimation({super.key,required this.image});

  @override
  State<ImageAnimation> createState() => _ImageAnimationState();
}

class _ImageAnimationState extends State<ImageAnimation>
    with TickerProviderStateMixin {
  final Random _random = Random();

  late AnimationController animationController;
  // Animation Variables
  late Animation<double> currentAnimation;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    currentAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose(); // Dispose the AnimationController here
    super.dispose();
  }

  void _setRandomAnimation(String currentAnimationType) {
    if (animationController.isAnimating ||
        animationController.status == AnimationStatus.completed) {
      animationController
          .reset(); // Reset the animation if it's currently running or completed
    }

    switch (currentAnimationType) {
      case 'fade':
        currentAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

        break;
      case 'scale':
        currentAnimation =
            Tween<double>(begin: 0.5, end: 1.0).animate(animationController);
        break;
      case 'rotate':
        currentAnimation =
            Tween<double>(begin: 0.0, end: 2 * pi).animate(animationController);
        break;
      default:
        currentAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    }
    animationController.forward();
  }

  String _getRandomAnimationType() {
    final animations = ['fade', 'scale', 'rotate'];
    return animations[_random.nextInt(animations.length)];
  }

  @override
  Widget build(BuildContext context) {
    final currentAnimationType = _getRandomAnimationType();
    _setRandomAnimation(currentAnimationType);
    return AnimatedBuilder(
      animation: currentAnimation,
      builder: (context, child) {
        switch (currentAnimationType) {
          case 'scale':
            return Transform.scale(
              scale: currentAnimation.value,
              child: child,
            );

          case 'rotate':
            return Transform.rotate(
              angle: currentAnimation.value,
              child: child,
            );

          case 'fade':
          default:
            return Opacity(
              opacity: currentAnimation.value,
              child: child,
            );
        }
      },
      child: widget.image,
    );
  }
}
