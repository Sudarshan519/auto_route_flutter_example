import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

import 'image_utils.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textDetector = GoogleVision.instance.textRecognizer();
  var detected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final image = await ImagePicker.platform
                      .pickImage(source: ImageSource.gallery,);
                  // cropping an image can save time uploading the image to Google
             
                  var det = await textDetector.processImage(
                      GoogleVisionImage.fromFilePath(image!.path));
                  // detected = det.text;
                  print(det.text);
                  // det.blocks.forEach((element) {
                  //   print(element);
                  // });
                  // setState(() {});
                },
                child: Text("Pick Image")),
            // if (detected != null) Text(detected.toString())
          ],
        ),
      ),
    );
  }
}
