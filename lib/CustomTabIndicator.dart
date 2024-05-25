
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTabIndicator extends Decoration {
  final double indicatorWidth;
  final Color color;

  CustomTabIndicator({required this.indicatorWidth, required this.color});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, indicatorWidth, color);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double indicatorWidth;
  final Color color;

  _CustomPainter(this.decoration, this.indicatorWidth, this.color);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    final double width = indicatorWidth;
    final double height = 48.0;
    final double xOffset = (configuration.size!.width / 2) - (width / 2);
    final double yOffset = configuration.size!.height - height;

    final Rect rect = Offset(offset.dx + xOffset, offset.dy + yOffset) & Size(width, height);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(3.0));
    canvas.drawRRect(rrect, paint);
  }
}
