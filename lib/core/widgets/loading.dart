import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EqualizerLoading(),
    );
  }
}

class EqualizerLoading extends StatefulWidget {
  const EqualizerLoading({
    super.key,
    this.color = Colors.white,
    this.size = 100,
    this.barCount = 5,
    this.barWidthFactor = 0.09,
    this.spacingFactor = 0.10,
    this.minHeightFactor = 0.12,
    this.speed = const Duration(milliseconds: 900),
  });

  final Color color;
  final double size;
  final int barCount;
  final double barWidthFactor;
  final double spacingFactor;
  final double minHeightFactor;
  final Duration speed;

  @override
  State<EqualizerLoading> createState() => _EqualizerLoadingState();
}

class _EqualizerLoadingState extends State<EqualizerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  // frameA: the second bar has the greatest height
  static const frameA = [0.25, 1.00, 0.55, 0.40, 0.15];

  // frameB: the third bar has the greatest height
  static const frameB = [0.70, 0.40, 1.00, 0.15, 0.30];

  late final List<Animation<double>> _bars;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.speed,
    )..repeat();

    _bars = List.generate(widget.barCount, _buildBarAnimation);
  }

  Animation<double> _buildBarAnimation(int index) {
    final a = frameA[index.clamp(0, frameA.length - 1)];
    final b = frameB[index.clamp(0, frameB.length - 1)];

    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: a,
          end: b,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: b,
          end: a,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 50,
      ),
    ]).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant EqualizerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _animationController
        ..duration = widget.speed
        ..repeat();
    }
  }

  List<Widget> _generateBars() {
    final barWidth = widget.size * widget.barWidthFactor;
    final spacing = widget.size * widget.spacingFactor;
    final barHeightCal =
        widget.size * (widget.minHeightFactor + (1 - widget.minHeightFactor));

    return List.generate(widget.barCount, (index) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing / 2,
        ),
        child: AnimatedBuilder(
          animation: _bars[index],
          builder: (context, _) {
            final barHeight = barHeightCal * _bars[index].value;
            return Container(
              width: barWidth,
              height: barHeight,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(
                  barWidth / 2,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _generateBars(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
