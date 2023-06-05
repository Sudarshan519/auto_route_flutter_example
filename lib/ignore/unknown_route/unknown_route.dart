import 'package:auto_route/auto_route.dart';
import 'package:autoroute_app/ignore/app_router.gr.dart';
import 'package:autoroute_app/ignore/unknown_route/ml_vision.dart';
import 'package:autoroute_app/ignore/unknown_route/render_backgorund.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'clipper.dart';

@RoutePage()
class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow,
      body: SafeArea(
        child: Column(
          // fit: StackFit.passthrough,
          children: [
            Container(
                // color: Colors.red,
                ),
            // MyHomePage()
            ElevatedButton(
                onPressed: () {
                  context.router.push(MlVisionRoute());
                  //
                },
                child: Text("MLVISION")),
            ElevatedButton(
                onPressed: () {
                  context.router.push(OCRTextRecognitionRoute(number: ''));
                },
                child: Text("TEXT RECOGNITION"))
            // MlVision(),
            // RenderClippedBackground(),
            // ClipOval(
            //   child: Center(
            //     child: Container(
            //       color: Colors.white,
            //       height: 100,
            //       width: 100,
            //     ),
            //   ),
            // )
            // RenderCircle(),
            // RenderWidgetBackgroundVisibleCenterGreyedOval(),
            // Center(child: Image.network('https://i.stack.imgur.com/vld34.png')),
            // Text("HELLO"),
            // Container(
            //   color: Colors.black.withOpacity(.5),
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     // color: Colors.black.withOpacity(.5),
            //     color: Colors.grey[300],
            //   ),
            //   width: 200,
            //   height: 200,
            // ),
            // OutsideCircle(),
            // TransparentCircle(),
            // Center(child: TestPage()),

            // ShaderMask(
            //   shaderCallback: (bounds) =>
            //       LinearGradient(colors: [Colors.grey], stops: [0.0])
            //           .createShader(bounds),
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: ClipOval(
            //         child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white.withOpacity(.6),
            //         // color: Colors.red.withOpacity(.2),
            //         // border: Border.all(color: Colors.white, width: 1),
            //         // borderRadius: BorderRadius.all(
            //         //   Radius.circular(MediaQuery.of(context).size.height / 2),
            //         // ),
            //       ),
            //       alignment: Alignment.center,
            //       width: MediaQuery.of(context).size.width / 1.2,
            //       height: MediaQuery.of(context).size.height / 2,
            //     )),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class Cutout extends StatelessWidget {
  const Cutout({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcOut,
      shaderCallback: (bounds) =>
          LinearGradient(colors: [color], stops: [0.0]).createShader(bounds),
      child: child,
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        // image: DecorationImage(
        //     image: NetworkImage('https://i.stack.imgur.com/vld34.png'),
        //     fit: BoxFit.cover),
        backgroundBlendMode: BlendMode.color,
      ),
      child: Container(
        // color: Colors.red,

        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.darken,
          color: Colors.blue,
        ),
        child: CustomPaint(
          foregroundPainter: CutOutOvalPainter(),
          // painter: CutOutTextPainter(text: 'YOUR NAME'),
          // painter: CutOutOvalPainter(),

          child: ClipOval(
            child: Container(
              height: 150, width: 150,
              // width: 150,
              child: Transform.scale(
                scale: 2.2,
                child: Image.network(
                  'https://i.stack.imgur.com/vld34.png',
                  // fit: BoxFit.cover,
                  // height: null,
                  // width: null,
                ),
              ),
            ),
          ),
          // painter: CutOutTextPainter(text: 'YOUR NAME'),
        ),
      ),
    );
  }
}

class CutOutOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final angle = -math.pi / 4;
    Color paintColor = Color.fromRGBO(250, 154, 210, 1);
    Paint circlePaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    // canvas.rotate(angle);
    canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 150, height: 200),
        circlePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CutOutTextPainter extends CustomPainter {
  CutOutTextPainter({required this.text}) {
    _textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    _textPainter.layout();
  }

  final String text;
  late final TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the text in the middle of the canvas
    final textOffset =
        size.center(Offset.zero) - _textPainter.size.center(Offset.zero);
    final textRect = textOffset & _textPainter.size;

    // The box surrounding the text should be 10 pixels larger, with 4 pixels corner radius
    final boxRect = RRect.fromRectAndRadius(
        textRect.inflate(10.0), const Radius.circular(4.0));
    final boxPaint = Paint()
      ..color = Colors.white
      ..blendMode = BlendMode.srcOut;

    canvas.saveLayer(boxRect.outerRect, Paint());

    _textPainter.paint(canvas, textOffset);
    canvas.drawRRect(boxRect, boxPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CutOutTextPainter oldDelegate) {
    return text != oldDelegate.text;
  }
}

class TransparentCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: CustomPaint(
          size: Size(150, 200),
          painter: CirclePainter(),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 4.0;
    final double radius = size.width / 2 - strokeWidth / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw the transparent circle
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.0)
      ..style = PaintingStyle.fill;
    // canvas.drawCircle(Offset(centerX / 3, centerY), radius, paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(centerX, centerY), width: 150, height: 200),
        // Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        paint
          ..style = PaintingStyle.stroke
          ..color = Colors.white);
    // Draw the filled outside circle
    final Paint fillPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    final double fillRadius = radius + strokeWidth / 2;
    final double fillStartAngle = -math.pi / 2;
    final double fillEndAngle = math.pi * 1.5;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: fillRadius),
        fillStartAngle,
        fillEndAngle,
        true,
        fillPaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;
}

class OutsideCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(200, 200),
        painter: CirclePainter1(),
      ),
    );
  }
}

class CirclePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.0;
    final double radius = size.width / 2 - strokeWidth / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw the gray background
    final Paint grayPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius, grayPaint);

    // Draw the clear center
    final Rect centerRect = Rect.fromCircle(
        center: Offset(centerX, centerY), radius: radius - strokeWidth);
    final Paint centerPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawCircle(
        Offset(centerX, centerY), radius - strokeWidth, centerPaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;
}
