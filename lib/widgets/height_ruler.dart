import 'package:flutter/material.dart';

class WeightRuler extends StatefulWidget {
  const WeightRuler({
    super.key,
    this.minKg = 30,
    this.maxKg = 200,
    this.initialKg = 70,
    this.pixelsPerUnit = 10.0,
    this.onChanged,
  });

  final int minKg;
  final int maxKg;
  final int initialKg;
  final double pixelsPerUnit;
  final ValueChanged<int>? onChanged;

  @override
  State<WeightRuler> createState() => _WeightRulerState();
}

class _WeightRulerState extends State<WeightRuler> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    final initialOffset = (widget.initialKg - widget.minKg) * widget.pixelsPerUnit;
    _controller = ScrollController(initialScrollOffset: initialOffset);
  }

  void _onScrollEnd() {
    final offset = _controller.offset;
    final snapped = (offset / widget.pixelsPerUnit).round();
    final targetKg = (widget.minKg + snapped).clamp(widget.minKg, widget.maxKg);
    final targetOffset = (targetKg - widget.minKg) * widget.pixelsPerUnit;
    _controller.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
    );
    widget.onChanged?.call(targetKg);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (_) => _onScrollEnd(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Highlight ở giữa
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _CenterIndicatorPainterHorizontal()),
            ),
          ),
          SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: CustomPaint(
              size: Size(
                (widget.maxKg - widget.minKg) * widget.pixelsPerUnit,
                100,
              ),
              painter: _HorizontalTickPainter(
                min: widget.minKg,
                max: widget.maxKg,
                pixelsPerUnit: widget.pixelsPerUnit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterIndicatorPainterHorizontal extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final paint = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 3;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HorizontalTickPainter extends CustomPainter {
  _HorizontalTickPainter({
    required this.min,
    required this.max,
    required this.pixelsPerUnit,
  });

  final int min;
  final int max;
  final double pixelsPerUnit;

  @override
  void paint(Canvas canvas, Size size) {
    // Nền gradient nhẹ
    final bg = Paint()
      ..shader = LinearGradient(
        colors: [Colors.black, Colors.black87],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    for (int kg = min; kg <= max; kg++) {
      final x = (kg - min) * pixelsPerUnit;
      final isMajor = kg % 10 == 0;
      final isMid = kg % 5 == 0 && !isMajor;

      final tickHeight = isMajor ? 50.0 : isMid ? 34.0 : 22.0;
      final stroke = isMajor ? 2.0 : isMid ? 1.5 : 1.0;
      final tickPaint = Paint()
        ..color = isMajor ? Colors.white : Colors.white70
        ..strokeWidth = stroke;

      // Vẽ vạch từ dưới lên
      canvas.drawLine(
        Offset(x, size.height - 12),
        Offset(x, size.height - 12 - tickHeight),
        tickPaint,
      );

      if (isMajor) {
        final tp = TextPainter(
          text: TextSpan(
            text: '$kg kg',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, size.height - 12 - tickHeight - tp.height - 4));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HorizontalTickPainter old) =>
      old.min != min || old.max != max || old.pixelsPerUnit != pixelsPerUnit;
}
