import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:translator/translator.dart';
import 'package:autoroute_app/image_utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraPart extends StatefulWidget {
  const CameraPart({super.key, required this.cardNumber});
  final String cardNumber;
  @override
  State<CameraPart> createState() => _CameraPartState();
}

class _CameraPartState extends State<CameraPart> {
  late CameraController cameraController;
  var isCameraInitialized = false;
  late Timer timer;
  var newImage = "";
  var translated = '';
  var location = '';

  var location_en = '';
  final translator = GoogleTranslator();
  final TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.japanese);
  var recognizedText = 'Empty';
  RecognizedText recognizedBlocs = RecognizedText(text: '', blocks: []);
  void initializeCamera() async {
    try {
      var cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.high);

      await cameraController.initialize();

      cameraController.setFlashMode(FlashMode.off);
      isCameraInitialized = true;

      setState(() {});
      runtimer();
    } catch (e) {}
  }

  void recognizeText() async {
    if (recognizedBlocs.blocks.isEmpty) {
      var file = await cameraController.takePicture();
      // var newPath = await cropImage(file.path);    // newImage = newPath;
      // log(file.path + "IMAGE");
      var image = InputImage.fromFilePath(file.path);
      var regex =
          RegExp(r"^(\d{4}年)+$"); //(0[1-9]|1[012])月(0[1-9]|[12][0-9]|3[01])日
      try {
        var blocs = await textRecognizer.processImage(image);

        print(blocs.text);
        if (blocs.text.contains(
                // "番号" +
                widget.cardNumber)
            // &&
            //     // blocs.text.contains("RESIDENT CARD") &&
            //     // blocs.text.contains("GOVERNMENT OF JAPAN") &&
            //     // blocs.text.contains("NATIONALITY/REGION") &&
            //     // blocs.text.contains("PEROID OF VALIDITY") &&
            //     // blocs.text.contains("DATE OF BIRTH") &&

            //     // && blocs.text.contains("氏名")

            )
        // print(blocs.text);
        {
          // var regExp = RegExp(r'(\d{4}?\d\d?\d\d(\s|T)\d\d:?\d\d:?\d\d)');
          final match = regex.firstMatch(blocs.text);
          log(match.toString());
          // final matchedText = match?.group(0);
          // log(matchedText.toString());
          // regex.firstMatch(blocs.text);
          recognizedText = blocs.text;
          recognizedBlocs = blocs;

          recognizedBlocs.blocks.forEach((e) {
            if (e.text.contains("住居地")) {
              location = e.text;
              print(e.text);
              translator.translate(e.text).then(
                  (value) => {location_en = (value.text), setState(() {})});
            } else {
              // print(e.text);
              // print(false);
            }
          });

          // translator.translate(recognizedBlocs.text, to: 'en').then((result) =>
          //     translated = result + ("Source: \nTranslated: $result"));
          // setState(() {});
        }
      } catch (e) {}
    } else {
      if (isCameraInitialized) {
        cameraController.dispose();
        isCameraInitialized = false;
        setState(() {});
      }
    }
  }

  stopCamera() {
    isCameraInitialized = false;
    cameraController.dispose();
    timer.cancel();
    setState(() {});
  }

  void runtimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      recognizeText();
    });
  }

  void runModel() {}

  @override
  void initState() {
    initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    if (isCameraInitialized) stopCamera();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // cameraController.dispose();
    // isCameraInitialized = false;
    var nameIndex = 1;

    var name = "";

    // print(recognizedBlocs.text);
    RegExp regex = RegExp(r"\d{4}年\d{2}月\d{2}日");
    var dates = <String?>[];

    dates = regex
        .allMatches(recognizedBlocs.text)
        .map((match) => match.group(0))
        .toList();
    print(dates);
    // final bloc =
    //     recognizedBlocs.blocks.firstWhere((e) => e.text.contains(dates[0]!));
    var lowest = 0;
    if (dates.isNotEmpty)
      dates.forEach((element) {
        print(recognizedBlocs.blocks
            .firstWhere((e) => e.text.contains(element!))
            .boundingBox
            .right);
      });
    if (recognizedBlocs.blocks.isNotEmpty) {
      // nameIndex = recognizedBlocs.blocks.indexOf(
      //     recognizedBlocs.blocks.firstWhere((e) => e.text.contains("NAME")));

      var bottomDiff = 0.0;
      var leftDiff = 0.0;
      if (recognizedBlocs.blocks.isNotEmpty) {
        recognizedBlocs.blocks.forEach((e) {
          if (e.text.contains("在居地")) location = e.text;
          if (recognizedBlocs.blocks[nameIndex].boundingBox.bottom !=
              e.boundingBox.bottom) {
            var absdiff = (e.boundingBox.bottom -
                    recognizedBlocs.blocks[nameIndex].boundingBox.bottom)
                .abs();
            var left = (e.boundingBox.left -
                    recognizedBlocs.blocks[nameIndex].boundingBox.left)
                .abs();
            if (bottomDiff == 0) {
              bottomDiff = absdiff;
            } else if (leftDiff == 0) {
              leftDiff = left;
            } else {
              if (bottomDiff > absdiff) {
                bottomDiff = absdiff;
                print(bottomDiff);
                var index = nameIndex = recognizedBlocs.blocks.indexOf(e);
                if (recognizedBlocs.blocks[index].text != "NAME" &&
                    !recognizedBlocs.blocks[index].text.contains("GOV")) {
                  nameIndex = index;
                  print(recognizedBlocs.blocks[index].text);
                  name = recognizedBlocs.blocks[index].text;
                }
              }
            }
          }
        });
      }
    }

    String replaceFirstWord(String originalString, String newWord) {
      List<String> words = originalString.split(' ');

      if (words.isNotEmpty) {
        words[0] = newWord;
        return words.join(' ');
      } else {
        return originalString;
      }
    }

    // print(recognizedBlocs.blocks
    //     .firstWhere((e) => e.text.contains("R SHRESTHA RABINDRA"))
    //     .boundingBox
    //     .bottom);
    // print((389 - recognizedBlocs.blocks[nameIndex].boundingBox.bottom));

    // Using the Future API
    // translator.translate(recognizedBlocs.text, to: 'en').then((result) =>
    //     {print("Source: $input\nTranslated: $result"), setState(() {})});
    // print(bloc.boundingBox);
    return Scaffold(
      body: SafeArea(
        child: InkWell(
          // onTap: () {
          //   // isCameraInitialized ? stopCamera() : initializeCamera();
          // },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                isCameraInitialized
                    // ? InkWell(
                    //     onTap: () {
                    //       cameraController.setFocusPoint(Offset.zero);
                    //     },
                    //     child: CameraPreview(cameraController))
                    ?
                    // newImage.isNotEmpty
                    //     ? Image.file(File(newImage))
                    // :
                    SizedOverflowBox(
                        size: const Size(400, 200), // aspect is 1:1
                        alignment: Alignment.center,
                        child: CameraPreview(cameraController),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Card Number"),
                          Text(recognizedBlocs.blocks
                              .firstWhere((element) =>
                                  element.text.contains(widget.cardNumber))
                              .text),
                          Text("Date of Birth"),

                          Text(dates[0].toString()),
                          // Text("NAME"),

                          // Text(replaceFirstWord(name, "")),
                          Text("Other Dates" + "\n" + dates.toString()),
                          Text(location),
                          Text(location_en)
                          // Text(newdiff.toString())
                        ],
                      ),
                // Positioned(
                //     bottom: 0,
                //     child: ElevatedButton(
                //         onPressed: () {
                //           timer.cancel();
                //           cameraController.dispose();
                //           isCameraInitialized = true;
                //           // recognizeText();
                //         },
                //         child: const Text("Take picture"))),
                // Positioned(
                //   bottom: 0,
                //   child: Container(
                //     color: Colors.white,
                //     height: 300,
                //     width: MediaQuery.of(context).size.width,
                //     child: Stack(children: [
                //       SingleChildScrollView(
                //         child: SingleChildScrollView(
                //           scrollDirection: Axis.horizontal,
                //           child: Row(
                //             children: [
                //               Column(
                //                 children: [Text(translated)],
                //               ),
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   // Text(recognizedBlocs.text),
                //                   if (recognizedBlocs.text != '')
                //                     ...recognizedBlocs.blocks
                //                         .map(
                //                           (e) => Column(
                //                               children: e.lines
                //                                   .map((line) => Row(
                //                                         children: [
                //                                           Text(
                //                                             line.text
                //                                                 .replaceAll(
                //                                                     RegExp(
                //                                                         '\\s+'),
                //                                                     ' '),
                //                                             style: TextStyle(
                //                                                 fontSize: 12),
                //                                           ),
                //                                           // Text(
                //                                           //   line.boundingBox
                //                                           //       .toString(),
                //                                           //   style: TextStyle(
                //                                           //       fontSize: 12),
                //                                           // ),
                //                                         ],
                //                                       ))
                //                                   .toList()),
                //                         )
                //                         .toList()
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //     ]),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
