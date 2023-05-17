import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:autoroute_app/core/injections/http_injectable.dart';
import 'package:flutter/material.dart';
import 'package:autoroute_app/unknown_route/render_backgorund.dart';
import 'package:autoroute_app/unknown_route/text_recognition.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

@RoutePage()
class OCRTextRecognitionPage extends StatefulWidget {
  const OCRTextRecognitionPage({Key? key}) : super(key: key);

  @override
  _OCRTextRecognitionPageState createState() => _OCRTextRecognitionPageState();
}

class _OCRTextRecognitionPageState extends State<OCRTextRecognitionPage> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.japanese);
  final TextEditingController textEditingController = TextEditingController();

  var imagePath = '';
  var recognized = false;
  var recognizedNumber = "";
  late CameraController cameraController;
  var cameraInitialized = false;
  var isProcessing = false;

  bool textRecognized = false;
  fetchEveryFiveSeconds() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      RepositoryImpl().fetchEntries();
    });
  }

  pickImage() async {
    var result = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
    );
    if (result != null) {
      imagePath = result.path;
      recognizeTextImage();
      setState(() {});
    } else {
      throw Exception();
    }
  }

  recognizeTextImage() async {
    try {
      var image = InputImage.fromFilePath(imagePath);
      var data = await _textRecognizer.processImage(image);
      // text = data;

      // recognizedNumber = text.blocks
      //     .firstWhere((element) => element.text.contains("番号"))
      //     .text
      //     .toString()
      //     .replaceAll("番号", "");

      recognized = true;
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    // setupCameras();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // fetchEveryFiveSeconds();
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                  textRecognized = false;
                });
                setupCameras();
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      if (cameraInitialized)
                        Container(
                          color: Colors.black,
                          width: double.infinity,
                          child: InkWell(
                              onTap: () {
                                cameraController.setFocusPoint(Offset.zero);
                              },
                              child: CameraPreview(cameraController)),
                        ),
                      if (textRecognized)
                        Center(
                          child: Icon(
                            Icons.check_circle,
                            size: 100,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),

                if (imagePath != '') Image.file(File(imagePath)),
                const SizedBox(
                  height: 20,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton(
                //       style: OutlinedButton.styleFrom(),
                //       onPressed: () {
                //         pickImage();
                //       },
                //       child: const Text("Take Photo")),
                // ),
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
                  )
                else
                  Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                // if (recognized) ...[
                //   Text(text.blocks
                //       .firstWhere((element) => element.text.contains("番号"),
                //           orElse: () => TextBlock(
                //               text: 'text',
                //               lines: [],
                //               boundingBox:
                //                   Rect.fromPoints(Offset.zero, Offset.zero),
                //               recognizedLanguages: [],
                //               cornerPoints: []))
                //       .text
                //       .toString()),

                //   // ...text.blocks.map((e) => Column(
                //   //       crossAxisAlignment: CrossAxisAlignment.start,
                //   //       children: [
                //   //         // Text(e.text),
                //   //         // Text(
                //   //         //   e.boundingBox.toString(),
                //   //         // ),
                //   //         // Text(e.cornerPoints.toString()),
                //   //         // Text(e.recognizedLanguages.toString()),
                //   //       ],
                //   //     ))
                // ],
                // CustomPaint(
                //   // painter: MyPaint(),
                //   painter: HolePainter(),
                //   child: Container(),
                // ),
                // Container(height: 100, child: Text(text.text)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setupCameras() async {
    try {
      List<CameraDescription> cameras = await availableCameras();
      cameraController = CameraController(cameras.first, ResolutionPreset.high);
      await cameraController.initialize();

      cameraInitialized = true;
      setState(() {});
      cameraController.startImageStream((CameraImage image) {
        _processCameraImage(image, cameras.first.sensorOrientation);
      });
    } catch (e) {}
  }

  Future _processCameraImage(CameraImage image, orientation) async {
    if (isProcessing) return;
    isProcessing = true;
    setState(() {});
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation = InputImageRotationValue.fromRawValue(orientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    var data = await _textRecognizer.processImage(inputImage);
    isProcessing = false;
    if (textEditingController.text.isNotEmpty) {
      if (data.text.contains(textEditingController.text)) {
        textRecognized = true;
        //
        await cameraController.stopImageStream();
        cameraController.dispose();
        cameraInitialized = false;
        print(data.text);
      }
    }
    setState(() {
      // text = data;
    });
    // print(inputImage);
    // if (mounted)
    //   setState(() {
    //     text = data;
    //   });
  }
}
