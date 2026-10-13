import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'brand.dart';

class VidaRewardMoment extends StatelessWidget {
  const VidaRewardMoment({super.key, required this.points, required this.onContinue});
  final int points;
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 900),
    curve: VidaBrand.curve,
    builder: (context, t, _) => Stack(alignment: Alignment.center, children: [
      if (!MediaQuery.disableAnimationsOf(context)) Positioned.fill(
        child: IgnorePointer(child: CustomPaint(painter: _RewardPainter(t)))),
      Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Transform.scale(scale: .65 + .35 * t, child: Container(height: 82, width: 82,
          decoration: const BoxDecoration(color: VidaBrand.softPlum, shape: BoxShape.circle),
          child: const Icon(Icons.auto_awesome, color: VidaBrand.plum, size: 38))),
        const SizedBox(height: 22),
        const Text('A little win, all yours.', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Text('+$points points unlocked', style: const TextStyle(fontSize: 16, color: VidaBrand.plum)),
        const SizedBox(height: 25),
        FilledButton(style: FilledButton.styleFrom(backgroundColor: VidaBrand.plum),
          onPressed: onContinue, child: const Text('Keep exploring')),
      ])),
    ]),
  );
}
class _RewardPainter extends CustomPainter {
  _RewardPainter(this.t);
  final double t;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .36);
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi * 2 / 16;
      final distance = (40 + i % 3 * 18) * t;
      final p = Paint()..color = (i.isEven ? VidaBrand.plum : VidaBrand.lemon)
        .withOpacity((1 - t).clamp(0.0, 1.0).toDouble());
      canvas.drawCircle(center + Offset(math.cos(angle) * distance, math.sin(angle) * distance), 3, p);
    }
  }
  @override
  bool shouldRepaint(_RewardPainter oldDelegate) => oldDelegate.t != t;
}
