import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  var translatedBloc = '';
  var location_en = '';
  var imagePath = '';
  var name = '';
  var dob = '';
  var expiry = '';
  var address = '';
  final translator = GoogleTranslator();
  final TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.japanese);
  var recognizedText = 'Empty';
  RecognizedText recognizedBlocs = RecognizedText(text: '', blocks: []);
  Size imageSize = const Size(0, 0);
  var rowCol = [];
  void initializeCamera() async {
    // try {
    //   var cameras = await availableCameras();
    //   cameraController = CameraController(cameras[0], ResolutionPreset.high);

    //   await cameraController.initialize();

    //   cameraController.setFlashMode(FlashMode.off);
    //   isCameraInitialized = true;

    //   setState(() {});
    //   runtimer();
    // } catch (e) {}
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

        // print(blocs.text);
        translator.translate(recognizedBlocs.text).then((value) {
          translatedBloc = value.text;
          // print(value.text);
          setState(() {});
        });
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

          for (var e in recognizedBlocs.blocks) {
            if (e.text.split(' ').length == 3) {
              print(e.cornerPoints);
              print("${e.text}  NAMEABC");

              print(e.boundingBox.bottom - e.boundingBox.top);
            }

            ;
            if (e.text.contains("住居地")) {
              location = e.text;
              // print(e.text);
              translator.translate(e.text).then(
                  (value) => {location_en = (value.text), setState(() {})});
            } else {
              // print(e.text);
              // print(false);
            }
          }

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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recognizeText();
    });
  }

  void runModel() {}

  void extractName() {
    // name exist between 3 to 8 range
    /// contains 3 letters
    ///
    var corner0 = recognizedBlocs.blocks.reduce((value, element) =>
        value.boundingBox.top < element.boundingBox.top ? value : element);
    var corner1 = recognizedBlocs.blocks.reduce((value, element) =>
        value.boundingBox.left < element.boundingBox.left ? value : element);
    var corner2 = recognizedBlocs.blocks.reduce((value, element) =>
        value.boundingBox.right > element.boundingBox.right ? value : element);
    var corner3 = recognizedBlocs.blocks.reduce((value, element) =>
        value.boundingBox.bottom > element.boundingBox.bottom
            ? value
            : element);
    var top1 = (corner0.boundingBox.top);
    var left = (corner1.boundingBox.left);
    var right = (corner2.boundingBox.right);
    var bottom = (corner3.boundingBox.bottom);
    var height = bottom - top1;
    var width = right - left;
    // print(height);
    // print(width);
    print(width / height);

    var firstblock = recognizedBlocs.blocks.first;
    // var namePosition = (firstblock.boundingBox.top + 25 * width / height);
    // print(namePosition);
    // var name = recognizedBlocs.blocks.reduce((value, element) =>
    //     (value.boundingBox.top - namePosition).abs() <
    //             ((element.boundingBox.top - namePosition).abs())
    //         ? value
    //         : element);
    // if (name.text == 'NAME') {
    //   name = recognizedBlocs.blocks[6];
    // }
    // print(name.text);
    var topCorner = firstblock.boundingBox.left;
    var top = firstblock.boundingBox.top;

    var listContainsNames = recognizedBlocs.blocks.where((element) =>
        element.boundingBox.top < (firstblock.boundingBox.top + 80));
    // print(listContainsNames)
    var last = listContainsNames.reduce((value, element) =>
        element.boundingBox.right > value.boundingBox.right ? element : value);
    // print(last.text);
    // var name =
    //     recognizedBlocs.blocks.where((e) => (e.boundingBox.top) < (top + 50));
    // name.forEach((element) {
    //   // print(element.text);
    // });
    // print(recognizedBlocs.blocks[5].text);
    listContainsNames.forEach((element) {
      // print(element.boundingBox.top);
      // print(element.text);
      var splittedNames = element.text.split(' ');
      print(splittedNames);
      if (splittedNames.length > 2) {
        if (!element.text.startsWith("GOV")) {
          print(splittedNames.first.length);
          if (splittedNames.first.length <= 2) {
            name = element.text;
            // print(name);
            name = name.replaceAll("${splittedNames.first} ", '');
          } else {
            name = element.text;
          }
        }
      } else {
        // print(element.text);
      }
      ;
    });
  }

  extractCardNumber() {
    //  card number exist between 1 to 5
    // contain single word
  }

  extractAddresss() {
    // address exist between 7 to 14
    // constains single word
    var data = (recognizedBlocs.blocks
        .where((element) => element.text.contains('生年月日')));
    if (data.isNotEmpty) {
      print(data.first.text.replaceAll('\n', ''));
      if (data.first.text.contains('\n'))
        address = (data.first.text.split('\n').first);
      else {
        address = (data.first.text.split('\n').first);
      }
    }
    // print(recognizedBlocs.blocks.where((element) => false));
  }

  extractDOB() {
    // dob exist between 10 to 18
    // is in a specific format
    var dates = [];
    RegExp regex = RegExp(r"\d{4}年\d{2}月\d{2}日");
    dates = regex
        .allMatches(recognizedBlocs.text)
        .map((match) => match.group(0))
        .toList();
    dob = (dates[0]);
  }

  extractPeroidOfValidity() {
    // peroid of validity exist between last 20 to 30
    // is in a specific formatf
    var dates = [];
    RegExp regex = RegExp(r"\d{4}年\d{2}月\d{2}日");
    dates = regex
        .allMatches(recognizedBlocs.text)
        .map((match) => match.group(0))
        .toList();

    expiry = dates.last;
    print(dates.last);
  }

  expiryDate() {
    // is in a specific format
    // 20 to 24
  }
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

    String replaceFirstWord(String originalString, String newWord) {
      List<String> words = originalString.split(' ');

      if (words.isNotEmpty) {
        words[0] = newWord;
        return words.join(' ');
      } else {
        return originalString;
      }
    }

    // print(recognizedBlocs.text);

    var dates = <String?>[];

    if (recognizedBlocs.blocks.isNotEmpty) {
      extractDOB();
      extractPeroidOfValidity();
      extractAddresss();

      var lowest = 0;
      // nameIndex = recognizedBlocs.blocks.indexOf(
      //     recognizedBlocs.blocks.firstWhere((e) => e.text.contains("NAME")));

      var bottomDiff = 0.0;
      var leftDiff = 0.0;
      if (recognizedBlocs.blocks.isNotEmpty) {
        for (var e in recognizedBlocs.blocks) {
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
              // if (bottomDiff > absdiff) {
              //   bottomDiff = absdiff;
              //   var index = nameIndex = recognizedBlocs.blocks.indexOf(e);
              //   if (recognizedBlocs.blocks[index].text != "NAME" &&
              //       !recognizedBlocs.blocks[index].text.contains("GOV")) {
              //     nameIndex = index;

              //     name = recognizedBlocs.blocks[index].text;

              //     if (name.split(' ').first.length < 2) {
              //       name = name.replaceAll(name.split(' ').first, '');
              //     }
              //   }
              // }
            }
          }
        }
      }
      extractName();
    }
    // print(name);
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
                    // SizedOverflowBox(
                    //     size: const Size(400, 200), // aspect is 1:1
                    //     alignment: Alignment.center,
                    //     child: CameraPreview(cameraController),
                    //   )
                    CameraPreview(cameraController)
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  var file =
                                      await ImagePicker.platform.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  imagePath = file!.path;
                                  var imageDimen = await getImage(file.path);
                                  imageSize = imageDimen;
                                  print(imageDimen);
                                  var image =
                                      InputImage.fromFilePath(file!.path);
                                  var recognized =
                                      await textRecognizer.processImage(image);
                                  // print(recognized.text);

                                  print(recognized.blocks.length);

                                  recognized.blocks.sort((a, b) =>
                                      (a.boundingBox.top - b.boundingBox.top >
                                              5)
                                          ? a.boundingBox.top
                                              .compareTo(b.boundingBox.top)
                                          : 0);
                                  recognizedBlocs = recognized;
                                  // var rightElements = recognizedBlocs;
                                  // var index = recognizedBlocs.blocks.firstWhere(
                                  //     (element) =>
                                  //         element.text.contains('NAME'));
                                  // rightElements.blocks.sort((a, b) => b
                                  //     .boundingBox.right
                                  //     .compareTo(a.boundingBox.right));
                                  // rightElements.blocks.forEach((element) {
                                  //   print(element.text);
                                  // });
                                  // recognizedBlocs.blocks.sort((a, b) => a
                                  //     .boundingBox.left
                                  //     .compareTo(b.boundingBox.left));

                                  try {
                                    recognizedBlocs.blocks
                                        .firstWhere(
                                          (e) => e.text.contains('住居地'),
                                        )
                                        .text;
                                    translator
                                        .translate(recognizedBlocs.text)
                                        .then((value) => {
                                              translatedBloc = value.text,
                                              setState(() {})
                                            });
                                  } catch (e) {}
                                  setState(() {});
                                },
                                child: const Text("Pick From Gallery")),
                            if (recognizedBlocs.blocks.isNotEmpty) ...[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Transform.scale(
                                  scale: 1,
                                  child: Container(
                                      child: Stack(
                                    children: [
                                      Image.file(
                                        File(imagePath),
                                      ),
                                      ...recognizedBlocs.blocks
                                          .map((e) => Positioned(
                                              top: e.boundingBox.top,
                                              left: e.boundingBox.left,
                                              child: Text(
                                                recognizedBlocs.blocks
                                                        .indexOf(e)
                                                        .toString() +
                                                    // "," + ,${e.boundingBox.top}, ${e.boundingBox.left}
                                                    e.text,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    shadows: [
                                                      Shadow(
                                                          color: Colors.grey,
                                                          offset:
                                                              Offset(-1, -1)),
                                                      Shadow(
                                                          color: Colors.white,
                                                          offset: Offset(1, 1))
                                                    ]),
                                              )))
                                          .toList()
                                    ],
                                  )),
                                ),
                              ),
                              // Text("Card Number"),
                              // Text(recognizedBlocs.blocks
                              //     .firstWhere((element) => element.text.contains(
                              //         "TJ9596562OFA" // '番号' // widget.cardNumber,
                              //         ))
                              //     .text),
                              const Text("Date of Birth"),

                              Text(dob.toString()),
                              Text("NAME"),
                              Text(name),
                              Text("Address"),
                              Text(address),
                              Text("Peroid of Expiry"),
                              Text(expiry),
                              // Text(replaceFirstWord(name, "")),
                              // // Text("Other Dates" + "\n" + dates.toString()),
                              // Text(recognizedBlocs.blocks[2].text),
                              // Text(recognizedBlocs.text),
                              // Text(location_en),
                              // Text(translatedBloc),
                              // Text(recognizedBlocs.text),
                              // Text(newdiff.toString())
                              // Wrap(
                              //   children: [
                              //     ...recognizedBlocs.blocks.map((e) =>
                              //         recognizedBlocs.blocks.indexOf(e) != 0
                              //             ? recognizedBlocs
                              //                         .blocks[recognizedBlocs
                              //                                 .blocks
                              //                                 .indexOf(e) -
                              //                             1]
                              //                         .boundingBox
                              //                         .top !=
                              //                     e.boundingBox.top
                              //                 ? SizedBox(
                              //                     width: MediaQuery.of(context)
                              //                             .size
                              //                             .width /
                              //                         2,
                              //                     child: Text(e.text + "\t\n\n"
                              //                         // +
                              //                         // "\n" +
                              //                         // "${e.boundingBox.top} ${e.boundingBox.left}\n",
                              //                         ),
                              //                   )
                              //                 : SizedBox(
                              //                     width: MediaQuery.of(context)
                              //                             .size
                              //                             .width /
                              //                         2,
                              //                     child: Text(e.text + "\t\t"
                              //                         // +
                              //                         //     "\n" +
                              //                         //     "${e.boundingBox.top} ${e.boundingBox.left}\n",
                              //                         ),
                              //                   )
                              //             : SizedBox(
                              //                 width: MediaQuery.of(context)
                              //                         .size
                              //                         .width /
                              //                     2,
                              //                 child: Text(e.text + "\t\t"
                              //                     // +
                              //                     //     "\n" +
                              //                     //     "${e.boundingBox.top} ${e.boundingBox.left}\n",
                              //                     ),
                              //               ))
                              //   ],
                              // )
                            ]
                          ],
                        ),
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
