import 'package:auto_route/auto_route.dart';
import 'package:autoroute_app/camera_part.dart';
import 'package:autoroute_app/crop_image.dart';
import 'package:autoroute_app/ignore/unknown_route/text_recognition.dart';
import 'package:autoroute_app/recognizer/text_detector_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pkg/flutter_pkg.dart';
import 'package:flutter_pkg/src/models/state_log.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var cardNumber = '1234567';
  final cardType = "123456";

  bool showContinueDialog = false;
  final TextEditingController number = TextEditingController()
    ..text = "LD36246893EA";
  final TextEditingController name = TextEditingController()
    ..text = 'ADHIKARI KIYA';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter your card number"),
            TextFormField(
              controller: number,
              onChanged: (v) {
                cardNumber = v;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: name,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CameraExampleHome()));
              },
              child: Text("OPEN CAMERA"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DocumentVerification(
                            selectedCard: cardType,
                            cardNumber: cardNumber,
                            showContinueDialog: showContinueDialog,
                            state: KycStateLog.fromJson({}),
                          )));
                },
                child: const Text("EKYC")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TextRecognizerView()));
                },
                child: const Text("OCR ")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          OCRTextRecognitionPage(number: number.text)));

                  /// Direct Call TO SDK
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (_) => DocumentVerification(
                  //           selectedCard: cardType,
                  //           cardNumber: cardNumber,
                  //           showContinueDialog: showContinueDialog,
                  //           state: KycStateLog.fromJson({}),
                  //         )));
                },
                child: const Text("OCR with live feed")),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CameraPart(
                              cardNumber: number.text,
                              name: name.text,
                            )));
                  },
                  child: const Text("Picture on valid card number")),
            ),
          ],
        ),
      ),
    );
  }
}
