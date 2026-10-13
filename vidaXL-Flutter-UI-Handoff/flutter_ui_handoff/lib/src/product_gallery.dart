import 'package:flutter/material.dart';
import 'brand.dart';

class VidaProductGallery extends StatefulWidget {
  const VidaProductGallery({super.key, required this.images,
    required this.labels, required this.productName, required this.productId,
    this.height = 320});
  final List<ImageProvider> images;
  final List<String> labels;
  final String productName;
  final String productId;
  final double height;
  @override
  State<VidaProductGallery> createState() => _VidaProductGalleryState();
}
class _VidaProductGalleryState extends State<VidaProductGallery> {
  final _controller = PageController();
  int _index = 0;
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  void _select(int index) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.jumpToPage(index);
    } else {
      _controller.animateToPage(index, duration: VidaBrand.page, curve: VidaBrand.curve);
    }
  }
  void _zoom(int index) { showDialog<void>(context: context, builder: (context) =>
    Dialog.fullscreen(child: Scaffold(
      appBar: AppBar(title: Text(widget.labels[index]),
        leading: IconButton(tooltip: 'Close image', icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context))),
      body: InteractiveViewer(minScale: 1, maxScale: 3,
        child: Center(child: Image(image: widget.images[index],
          semanticLabel: '${widget.productName}: ${widget.labels[index]}'))),
    ))); }
  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty || widget.labels.length != widget.images.length) return const SizedBox(height: 220,
      child: Center(child: Text('Images unavailable')));
    final safeIndex = _index.clamp(0, widget.images.length - 1).toInt();
    return Column(children: [
      SizedBox(height: widget.height, child: Stack(children: [
        PageView.builder(controller: _controller, itemCount: widget.images.length,
          allowImplicitScrolling: true,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) => Semantics(
            label: '${widget.productName}, ${widget.labels[i]}, image ${i + 1} of ${widget.images.length}',
            button: true,
            child: GestureDetector(onTap: () => _zoom(i), child: Padding(
              padding: const EdgeInsets.all(24),
              child: Hero(tag: '${widget.productId}_image_$i', child: Image(
                image: widget.images[i], fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined)),
              )),
            )),
          )),
        Positioned(left: 16, top: 12, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text('${safeIndex + 1} / ${widget.images.length}', style: const TextStyle(fontSize: 12)),
        )),
        Positioned(right: 8, top: 4, child: IconButton(tooltip: 'Enlarge image',
          icon: const Icon(Icons.zoom_in), onPressed: () => _zoom(safeIndex))),
      ])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Flexible(child: Text(widget.labels[safeIndex], style: const TextStyle(fontSize: 12))),
          const Text('Swipe to explore', style: TextStyle(fontSize: 11, color: VidaBrand.muted))],
      )),
      const SizedBox(height: 12),
      Wrap(spacing: 10, runSpacing: 8, children: List.generate(widget.images.length, (i) =>
        Semantics(selected: i == safeIndex, label: 'Show ${widget.labels[i]}',
          child: InkWell(onTap: () => _select(i), borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(duration: VidaBrand.fast,
              width: 60, height: 56, padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: i == safeIndex ? VidaBrand.plum : VidaBrand.line,
                  width: i == safeIndex ? 2 : 1)),
              child: Image(image: widget.images[i], fit: BoxFit.contain),
            )),
        ))),
    ]);
  }
}
