import 'package:flutter/material.dart';

class CirclePaint extends CustomPainter {
  final double radius;
  CirclePaint({this.radius = 36});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.height, size.width),
        radius - 6,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromRGBO(255, 255, 255, 1));
    canvas.drawCircle(
        Offset(size.height, size.width),
        radius - 2,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.transparent);
    canvas.drawCircle(
        Offset(size.height, size.width),
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OvalPainter extends CustomPainter {
  // final Color color;

  // OvalPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width * 0.5, size.height * 0.5);
    int lineAmount = 10;
    Color paintColor = Colors.white;
    Paint circlePaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // HIGHLIGHT

    canvas.drawOval(Rect.fromLTRB(0, 0, size.width, size.height), circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
