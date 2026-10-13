import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'brand.dart';

class VidaPressFeedback extends StatefulWidget {
  const VidaPressFeedback({super.key, required this.child,
    required this.onTap, required this.label, this.haptic = false});
  final Widget child;
  final VoidCallback? onTap;
  final String label;
  final bool haptic;
  @override
  State<VidaPressFeedback> createState() => _VidaPressFeedbackState();
}
class _VidaPressFeedbackState extends State<VidaPressFeedback> {
  bool _pressed = false;
  void _tap() {
    if (widget.onTap == null) return;
    if (widget.haptic && !MediaQuery.disableAnimationsOf(context)) {
      HapticFeedback.selectionClick();
    }
    widget.onTap!();
  }
  @override
  Widget build(BuildContext context) => Semantics(
    button: true, enabled: widget.onTap != null, label: widget.label,
    onTap: widget.onTap == null ? null : _tap,
    child: GestureDetector(
      excludeFromSemantics: true,
      onTap: widget.onTap == null ? null : _tap,
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed && !MediaQuery.disableAnimationsOf(context) ? .975 : 1,
        duration: VidaBrand.fast, curve: VidaBrand.curve, child: widget.child),
    ),
  );
}

class VidaAnimatedPoints extends StatelessWidget {
  const VidaAnimatedPoints({super.key, required this.points, this.style});
  final int points;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) => Semantics(
    label: '$points available points',
    child: ExcludeSemantics(child: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: points.toDouble()),
      duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : VidaBrand.reward,
      curve: VidaBrand.curve,
      builder: (_, value, __) => Text(value.round().toString(), style: style),
    )),
  );
}
