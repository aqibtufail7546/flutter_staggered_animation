import 'package:flutter/material.dart';

class UnboxingAnimation extends StatefulWidget {
  final GlobalKey cartIconKey;
  final VoidCallback onComplete;

  const UnboxingAnimation({
    required this.cartIconKey,
    required this.onComplete,
    Key? key,
  }) : super(key: key);

  @override
  _UnboxingAnimationState createState() => _UnboxingAnimationState();
}

class _UnboxingAnimationState extends State<UnboxingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _lidSlideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _productScaleAnimation;
  late Animation<double> _boxScaleAnimation;
  late Animation<Offset> _cartAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _lidSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.45, curve: Curves.easeOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.6, curve: Curves.easeOut),
      ),
    );

    _productScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.75, curve: Curves.elasticOut),
      ),
    );

    _boxScaleAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _cartAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          widget.cartIconKey.currentContext?.findRenderObject() as RenderBox;
      final iconPosition = renderBox.localToGlobal(Offset.zero);
      final iconSize = renderBox.size;

      final screenSize = MediaQuery.of(context).size;
      final boxCenter = Offset(screenSize.width / 2, screenSize.height / 2);
      final targetCenter = Offset(
        iconPosition.dx + iconSize.width / 2,
        iconPosition.dy + iconSize.height / 2,
      );

      final relativeOffset = Offset(
        (targetCenter.dx - boxCenter.dx) / (screenSize.width / 2),
        (targetCenter.dy - boxCenter.dy) / (screenSize.height / 2),
      );

      _cartAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: relativeOffset,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
        ),
      );

      _controller.forward().then((_) {
        widget.onComplete();
        _controller.reset();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _cartAnimation.value,
          child: Transform.scale(
            scale: _boxScaleAnimation.value,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                  SlideTransition(
                    position: _lidSlideAnimation,
                    child: Container(
                      width: 190,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _productScaleAnimation,
                    child: const Icon(
                      Icons.shopping_bag,
                      size: 60,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
