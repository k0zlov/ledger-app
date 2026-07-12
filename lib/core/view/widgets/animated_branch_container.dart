import 'package:flutter/cupertino.dart';

class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
    super.key,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() => _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late int _previousIndex;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _isAnimating = false;
              _previousIndex = widget.currentIndex;
            });
          }
        });
  }

  @override
  void didUpdateWidget(AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _isAnimating = true;
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.children.length, (index) {
        final isCurrent = index == widget.currentIndex;
        final isPrevious = index == _previousIndex;
        final isGoingRight = widget.currentIndex > _previousIndex;

        if (!isCurrent && !isPrevious) {
          return Offstage(
            offstage: true,
            child: widget.children[index],
          );
        }

        if (!_isAnimating) {
          return Offstage(
            offstage: !isCurrent,
            child: widget.children[index],
          );
        }

        if (isCurrent) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: Offset(isGoingRight ? 1.0 : -1.0, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: widget.children[index],
          );
        }

        if (isPrevious) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(isGoingRight ? -1.0 : 1.0, 0),
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: widget.children[index],
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
