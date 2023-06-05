import 'dart:developer';

import 'package:autoroute_app/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'camera_view.dart';
import 'painters/text_detector_painter.dart';
import 'dart:io';

class TextRecognizerView extends StatefulWidget {
  const TextRecognizerView({super.key});

  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.japanese);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_text);
    return CameraView(
      title: 'Text Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage, {String? filepath}) {
        processImage(
          inputImage,
        );
      },
    );
  }

  Future<void> processImage(
    InputImage inputImage,
  ) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    log(((inputImage.inputImageData?.size).toString()) +
        "IMAGE" +
        (inputImage.inputImageData?.imageRotation).toString());
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextRecognizerPainter(
          recognizedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Recognized text:\n\n${recognizedText.text}';
      // File image =
      //     new File('image.png'); // Or any other way to get a File instance.
      // var decodedImage = await decodeImageFromList(image.readAsBytesSync());
      if (inputImage.inputImageData?.size != null &&
          inputImage.inputImageData?.imageRotation != null) {
        //   final painter = TextRecognizerPainter(
        //       recognizedText, Size(400, 400), InputImageRotation.rotation0deg);
        //   _customPaint = CustomPaint(painter: painter);
        // TODO: set _customPaint to draw boundingRect on top of image
        _customPaint = null;
      }
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
