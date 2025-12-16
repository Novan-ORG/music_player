import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    this.speed = const Duration(milliseconds: 1200),
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
  late final AnimationController _c;

  // frameA: the second bar has the greatest height
  static const frameA = [0.25, 1.00, 0.55, 0.40, 0.15];

  // frameB: the third bar has the greatest height
  static const frameB = [0.70, 0.40, 1.00, 0.15, 0.30];

  late final List<Animation<double>> _bars;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.speed)..repeat();

    _bars = List.generate(widget.barCount, (i) {
      final a = frameA[i.clamp(0, frameA.length - 1)];
      final b = frameB[i.clamp(0, frameB.length - 1)];

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
      ]).animate(_c);
    });
  }

  @override
  void didUpdateWidget(covariant EqualizerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _c
        ..duration = widget.speed
        ..repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barWidth = widget.size * widget.barWidthFactor;
    final spacing = widget.size * widget.spacingFactor;
    final radius = barWidth / 2;

    final minH = widget.size * widget.minHeightFactor;
    final maxH = widget.size;

    return SizedBox(
      height: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.barCount, (i) {
              final v = _bars[i].value; // 0..1
              final h = minH + (maxH - minH) * v;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                child: SizedBox(
                  width: barWidth,
                  height: widget.size,
                  child: Center(
                    child: Container(
                      width: barWidth,
                      height: h,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(radius),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class EqualizerLoadingWithPackage extends StatelessWidget {
  const EqualizerLoadingWithPackage({
    super.key,
    this.color = Colors.white,
    this.size = 80,
    this.duration = const Duration(milliseconds: 1400),
  });

  final Color color;
  final double size;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      size: size,
      type: SpinKitWaveType.center,
      duration: duration,
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
        );
      },
    );
  }
}
