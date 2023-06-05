import 'dart:async';
import 'dart:io';

import 'package:autoroute_app/ignore/core/injections/http_injectable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MyPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // below one is big circle and instead of this circle you can draw your shape here.
    canvas.drawCircle(
        const Offset(200, 200),
        100,
        Paint()
          ..color = Colors.orange[200]!
          ..style = PaintingStyle.fill);

    // below the circle which you want to create a cropping part.
    RRect rRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(200, 200), width: 100, height: 75),
        const Radius.circular(8));
    canvas.drawRRect(
        rRect,
        Paint()
          ..color = Colors.orange[200]!
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.dstOut);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class HolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.blue;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(
              size.height, size.height, 300, 300, const Radius.circular(50))),
        Path()
          ..addOval(Rect.fromCircle(center: const Offset(200, 200), radius: 60))
          ..close(),
      ),
      paint,
    );

//     final Path path = Path();
// path.fillType = PathFillType.evenOdd;
// path.addOval(Rect.fromCircle(center: center, radius: radius));
// path.addRRect(RRect.fromRectAndRadius(
//     Rect.fromCircle(center: center, radius: radius / 2),
//     Radius.circular(radius / 10)));
// canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var path = Path();
    path.lineTo(0, height - 50);
    // path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, height - 50);
    path.lineTo(width, 0);
    // path.lineTo(height, width);
    // path.lineTo(0, width);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OCRTextRecognition(),
    );
  }
}

class OCRTextRecognition extends StatefulWidget {
  const OCRTextRecognition({Key? key}) : super(key: key);

  @override
  _OCRTextRecognitionState createState() => _OCRTextRecognitionState();
}

class _OCRTextRecognitionState extends State<OCRTextRecognition> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.japanese);
  final TextEditingController textEditingController = TextEditingController();
  late RecognizedText text;
  var imagePath = '';
  var recognized = false;
  var recognizedNumber = "";
  fetchEveryFiveSeconds() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      RepositoryImpl().fetchEntries();
    });
  }

  pickImage() async {
    var result = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      maxHeight: 1280,
      maxWidth: 720,
    );
    if (result != null) {
      imagePath = result.path;
      recognizeTextImage();
      setState(() {});
    } else
      throw Exception();
  }

  recognizeTextImage() async {
    try {
      var image = InputImage.fromFilePath(imagePath);
      var data = await _textRecognizer.processImage(image);
      text = data;
      print(data.text);
      recognizedNumber = text.blocks
              .firstWhere((element) => element.text.contains("番号"))
              .text
              .toString() ??
          "";
      recognized = true;
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // fetchEveryFiveSeconds();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter your card number"),
            TextFormField(
              controller: textEditingController,
              onChanged: (v) {
                setState(() {
                  recognizedNumber == v ? true : false;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  recognizedNumber == value ? true : false;
                });
              },
            ),
            if (imagePath != '') Image.file(File(imagePath)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(),
                  onPressed: () {
                    pickImage();
                  },
                  child: const Text("Take Photo")),
            ),
            const SizedBox(
              height: 20,
            ),
            // SizedBox(
            //     width: double.infinity,
            //     child: OutlinedButton(
            //         onPressed: () {
            //           recognizeTextImage();
            //         },
            // child: const Text("Verify"))),
            const SizedBox(
              height: 20,
            ),

            if (recognizedNumber.replaceAll("番号", "") ==
                    textEditingController.text &&
                recognizedNumber != "")
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            if (recognized) ...[
              Text(text.blocks
                  .firstWhere((element) => element.text.contains("番号"))
                  .text
                  .toString()),
              Text(text.text),
              ...text.blocks.map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.text),
                      Text(
                        e.boundingBox.toString(),
                      ),
                      Text(e.cornerPoints.toString()),
                      // Text(e.recognizedLanguages.toString()),
                    ],
                  ))
            ]

            // CustomPaint(
            //   // painter: MyPaint(),
            //   painter: HolePainter(),
            //   child: Container(),
            // ),
          ],
        ),
      ),
    );
  }
}
