import 'package:flutter/material.dart';
import 'brand.dart';

class VidaSplash extends StatefulWidget {
  const VidaSplash({super.key, required this.onContinue, this.ready = true,
    this.bedroom = const AssetImage('assets/bedroom.jpg', package: 'vidaxl_ui_handoff'),
    this.garden = const AssetImage('assets/garden.jpg', package: 'vidaxl_ui_handoff')});
  final VoidCallback onContinue;
  final bool ready;
  final ImageProvider bedroom;
  final ImageProvider garden;
  @override
  State<VidaSplash> createState() => _VidaSplashState();
}
class _VidaSplashState extends State<VidaSplash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) { _controller.stop(); _controller.value = 1; }
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  Widget _photo(ImageProvider image, double angle, double width, double height) =>
    Transform.rotate(angle: angle, child: Container(width: width, height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x18232323), blurRadius: 25, offset: Offset(0, 12))]),
      padding: const EdgeInsets.all(5), child: ClipRRect(borderRadius: BorderRadius.circular(16),
        child: Image(image: image, fit: BoxFit.cover))));
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.white,
    body: SafeArea(child: LayoutBuilder(builder: (context, bounds) =>
      SingleChildScrollView(child: ConstrainedBox(constraints: BoxConstraints(minHeight: bounds.maxHeight),
        child: AnimatedBuilder(animation: _controller, builder: (context, _) {
          final t = VidaBrand.curve.transform(_controller.value);
          return Stack(children: [
            Positioned(top: 210, left: 25, right: 25, child: Container(height: 320,
              decoration: const BoxDecoration(shape: BoxShape.circle,
                gradient: RadialGradient(colors: [Color(0x90EFDBEC), Colors.white])))),
            Positioned(top: 28 + (1 - t) * 24, left: 30,
              child: Opacity(opacity: t, child: _photo(widget.bedroom, -.14, 137, 159))),
            Positioned(top: 75 + (1 - t) * 30, right: 28,
              child: Opacity(opacity: t, child: _photo(widget.garden, .14, 111, 126))),
            Positioned(top: 31, right: 148, child: Transform.scale(scale: .3 + .7 * t,
              child: const Icon(Icons.auto_awesome, color: VidaBrand.lemon, size: 30))),
            Padding(padding: const EdgeInsets.fromLTRB(28, 235, 28, 40),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Opacity(opacity: t, child: Transform.translate(offset: Offset(0, (1 - t) * 10),
                  child: const VidaLogo())),
                const SizedBox(height: 30),
                const Text('LIVE IT UP FOR LESS', style: TextStyle(fontSize: 10,
                  letterSpacing: 2, color: VidaBrand.plum, fontWeight: FontWeight.w600)),
                const SizedBox(height: 15),
                const Text('A little more home.\nA little more you.', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, height: 1.25, fontWeight: FontWeight.w600, color: VidaBrand.ink)),
                const SizedBox(height: 13),
                const Text('Thoughtful finds. Little rewards.\nMade for the way you live.', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, height: 1.7, color: VidaBrand.muted)),
                const SizedBox(height: 23),
                const Text('Discover   ·   Bid   ·   Earn', style: TextStyle(fontSize: 12, color: VidaBrand.plum)),
                const SizedBox(height: 28),
                FilledButton(style: FilledButton.styleFrom(backgroundColor: VidaBrand.plum,
                  foregroundColor: Colors.white, minimumSize: const Size(200, 48)),
                  onPressed: widget.ready ? widget.onContinue : null,
                  child: Text(widget.ready ? 'Enter the experience' : 'Getting ready…')),
              ])),
          ]);
        }),
      )),
    )),
  );
}
