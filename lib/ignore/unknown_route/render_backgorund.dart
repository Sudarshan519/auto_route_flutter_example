import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RenderWidgetBackgroundVisibleCenterGreyedOvalPage
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background widget
          Image.network('https://i.stack.imgur.com/vld34.png',
              fit: BoxFit.cover),
          // Grey oval with clear center
          Center(
            child: CustomPaint(
              size: Size(300, 200),
              painter: OvalPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.0;
    final double width = size.width - strokeWidth;
    final double height = size.height - strokeWidth;
    final double radiusX = width / 2;
    final double radiusY = height / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw the gray background oval
    final Paint grayPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;
    canvas.drawOval(
        Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, width, height),
        grayPaint);

    // Draw the clear center
    final Rect centerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        width - strokeWidth * 2, height - strokeWidth * 2);
    final Paint centerPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawOval(centerRect, centerPaint);
  }

  @override
  bool shouldRepaint(OvalPainter oldDelegate) => false;
}

class RenderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.yellow, Colors.green],
                radius: 0.5,
                center: Alignment.center,
              ),
            ),
          ),
          CustomPaint(
            size: Size(200, 200),
            painter: CirclePainter1(),
          ),
        ],
      ),
    );
  }
}

class CirclePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.0;
    final double radius = (size.width - strokeWidth) / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw the empty center circle
    final Paint emptyPaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(centerX, centerY), radius, emptyPaint);

    // Draw the filled outside circle
    final Paint filledPaint = Paint()..color = Colors.grey[300]!;
    canvas.drawCircle(
        Offset(centerX, centerY), radius - strokeWidth / 2, filledPaint);
  }

  @override
  bool shouldRepaint(CirclePainter1 oldDelegate) => false;
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Define the oval shape
    final radiusX = size.width / 2;
    final radiusY = size.height / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    path.addOval(Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: radiusX * 2,
        height: radiusY * 2));

    return path;
  }

  @override
  bool shouldReclip(OvalClipper oldClipper) => false;
}

class RenderClippedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: Container(
          width: 200,
          height: 120,
          child: Stack(
            children: [
              Center(
                child: Text(
                  'Hello, World!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              // The background clipper
              ClipPath(
                clipper: OvalClipper(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              // The text widget in the center
            ],
          ),
        ),
      ),
    );
  }
}
