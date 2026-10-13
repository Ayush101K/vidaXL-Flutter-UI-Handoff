import 'package:flutter/material.dart';

abstract final class VidaBrand {
  static const plum = Color(0xFF93117E);
  static const softPlum = Color(0xFFF9F1F7);
  static const lemon = Color(0xFFF3D018);
  static const ink = Color(0xFF232323);
  static const muted = Color(0xFF6A6A6A);
  static const line = Color(0xFFE3E3E3);
  static const success = Color(0xFF048259);
  static const fast = Duration(milliseconds: 140);
  static const page = Duration(milliseconds: 260);
  static const reward = Duration(milliseconds: 650);
  static const curve = Curves.easeOutCubic;
}

class VidaLogo extends StatelessWidget {
  const VidaLogo({super.key, this.width = 142, this.showPlus = true});
  final double width;
  final bool showPlus;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset('assets/logo.png', package: 'vidaxl_ui_handoff',
        width: width, semanticLabel: 'vidaXL'),
      if (showPlus) Padding(padding: const EdgeInsets.only(left: 7),
        child: Text('+', style: TextStyle(fontSize: width * .29,
          fontWeight: FontWeight.w600, color: VidaBrand.plum))),
    ],
  );
}
