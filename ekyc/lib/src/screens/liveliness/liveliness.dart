import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/src/screens/intro_screen/intro_screen.dart';
import 'package:flutter_pkg/src/document_verification.dart';
import 'package:flutter_pkg/src/utils/img_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';

class LivelinessMlKit extends StatefulWidget {
  const LivelinessMlKit({Key? key}) : super(key: key);

  @override
  State<LivelinessMlKit> createState() => _LivelinessMlKitState();
}

class _LivelinessMlKitState extends State<LivelinessMlKit> {
  var cameras = [];
  var cameraInitilized = false;
  var blinkCount = 0;
  var faceDetected = false;
  var isRunning = false;
  var blinkDetected = false;
  var isNavigating = false;

  int x = 0, y = 0, z = 0;
  late CameraController controller;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
        enableTracking: true),
  );
  final MainController mainController = Get.find();
  var faceTimeStamp;
  var blinkTimeStamp;
  var loading = false;
  var captured = false;
  var showBoundingBox = true;
  var path;
  var tick = 3;
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  var isManual = false;
  late Timer timer;
  takePicture(cameraImage) async {
    await controller.stopImageStream();

    if (cameraImage.planes[0].bytesPerRow == cameraImage.width) {
      loading = true;
      captured = true;
      if (mounted) setState(() {});
      var image = await convertYUV420toImageColor(cameraImage, rotate: true);
      Directory appDocDir = await getTemporaryDirectory();
      String appDocPath = appDocDir.path;

      var file = File(
          "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");
      await file.writeAsBytes(image);

      mainController.blink(file.path);

      try {
        // showLoading(context);
        // // await mainController.updateState(AppStrings.BLINK);
        // if (mounted) Navigator.pop(context);

        mainController.nextPage();
      } catch (e) {
        // if (mounted) Navigator.pop(context);
        showDialog(
            context: context,
            builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Failed to upload file"),
                    InkWell(onTap: () {}, child: const Text("Retry"))
                  ],
                ));
      }
    } else {
      showLoading(context);
      faceDetected = false;
      showBoundingBox = false;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 20));
      var path = (await FlutterNativeScreenshot.takeScreenshot())!;
      Directory appDocDir = await getTemporaryDirectory();
      String appDocPath = appDocDir.path;

      var file = File(
          "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");
      var img = await cropSelfie(path);
      await file.writeAsBytes(img);

      mainController.blink(file.path);

      if (mounted) Navigator.pop(context);

      mainController.nextPage();
    }
  }

  // uploadImage() async {
  //   showLoading(context);
  //   try {
  //     await mainController.updateState(AppStrings.BLINK);
  //     if (mounted) Navigator.pop(context);
  //     if (!isNavigating) mainController.nextPage();
  //   } catch (e) {}
  // }

  @override
  void initState() {
    super.initState();
    initCameraModule();
    _streamSubscriptions.add(accelerometerEvents.listen(
      (data) {
        checkAngle(data);
      },
    ));
  }

  initCameraModule() async {
    cameras = await availableCameras();
    setState(() {});
    var cameraDescirption = cameras[1];
    controller = CameraController(cameraDescirption, ResolutionPreset.high,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.yuv420);
    await controller.initialize().then((_) {
      setState(() {
        cameraInitilized = true;
      });
      controller.startImageStream(runMLModel);
    });
  }

  void checkAngle(AccelerometerEvent data) {
    if (x == data.x.round() &&
        y == data.y.round() &&
        z == data.z.round() &&
        z > .5 &&
        z < 2 &&
        y > 8 &&
        x < 1) {
      if (mounted) {
        if (!isNavigating) {
          if (blinkTimeStamp != null && faceTimeStamp != null) {
            if ((blinkTimeStamp - faceTimeStamp) > 100) {
              isNavigating = true;
              vibrate();
              Future.delayed(0.seconds, () {});
            }
          }
        }
      }
    } else {
      x = data.x.round();
      y = data.y.round();
      z = data.z.round();
      clearBlinks();
    }
  }

  void takePictureManual() async {
    loading = true;
    captured = true;

    if (tick < 1) {
      Get.find<MainController>().logProvider.sendLog(
          "Front picture captured success.",
          funcName: "FaceDetectionPage -> takePicture()",
          label: "EKYC Face",
          errorMsg: "Front picture captured success");
      if (mounted) setState(() {});
      var file = await controller.takePicture();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      var newfile = File(
          "${appDocPath + DateTime.now().millisecondsSinceEpoch.toString()}.png");
      var image = await flipImage(file.path);

      await newfile.writeAsBytes(image);
      path = newfile.path;
      mainController.blink(path);
      var base64 = base64Encode(image);
      mainController.blinkByte(base64);
      mainController.ekycStateStorage.blinkImageByte = base64;

      Future.delayed(Duration.zero, () {
        loading = false;
        if (mounted) setState(() {});
      });
      mainController.nextPage();
      // uploadImage();
    } else {
      timer = Timer.periodic(1.seconds, (t) {
        if (tick < 1) {
          takePictureManual();

          timer.cancel();
        } else {
          tick -= 1;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (cameraInitilized)
            Center(
                child: SizedBox(
                    width: double.infinity, child: CameraPreview(controller))),
          if (!isManual && showBoundingBox)
            Center(
              child: faceDetected
                  ? Image.asset(
                      getassetPath("camera_frame_active.webp"),
                      height: 330.r,
                      width: 380.r,
                    )
                  : Image.asset(
                      getassetPath("camera_frame_inactive.webp"),
                      height: 330.r,
                      width: 380.r,
                    ),
            ),

          if (isManual)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade600.withOpacity(.4),
                ),
                height: 200,
                width: 200,
                alignment: Alignment.center,
                child: Text(
                  tick.toString(),
                  style: TextStyle(fontSize: 40.sp, color: Colors.white),
                ),
              ),
            ),
          // if (!faceDetected)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                alignment: Alignment.center,
                height: 80.h,
                child: Text(
                  "Position your face in the frame and blink twice.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 18.r, color: Colors.white),
                ),
              )),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: const Color(0xff393939),
                width: double.infinity,
                alignment: Alignment.center,
                height: 96.h,
                child: SafeArea(
                  child: Text(
                    "Selfie",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                alignment: Alignment.center,
                // padding: EdgeInsets.symmetric(vertical: 20.r),
                height: 80.h,
                child: Text(
                  "Blink",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 18.r, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }

  runMLModel(CameraImage image) async {
    if (isRunning) return;
    isRunning = true;

    if (image.planes.first.bytesPerRow != image.width && Platform.isAndroid) {
      await controller.stopImageStream();

      isManual = true;
      takePictureManual();
    }
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[1];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
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
    final faces = await _faceDetector.processImage(inputImage);
    isRunning = false;
    if (!blinkDetected) {
      if (faces.isNotEmpty) {
        for (Face face in faces) {
          blinkTimeStamp = DateTime.now().millisecondsSinceEpoch;

          if ((face.leftEyeOpenProbability ?? 99) < .2) {
            blinkDetected = true;
            takePicture(image);
            Get.find<MainController>().logProvider.sendLog("Blink Detection",
                funcName: "LivelinessPage->takePicture()",
                label: "EKYC Liveliness",
                errorMsg: "Success detecting blink");
          } else {
            faceTimeStamp = DateTime.now().millisecondsSinceEpoch;
            if (faceDetected != true && face.leftEyeOpenProbability! > .2) {
              if (mounted) {
                setState(() {
                  faceDetected = true;
                });
              }
            }
          }
        }
      }
    } else {
      faceDetected = false;
      if (faceDetected != false) {
        setState(() {});
      }
    }
  }

  void clearBlinks() {
    faceDetected = false;
    blinkDetected = false;
    blinkCount = 0;
  }
}

void vibrate() async {
  // if (await Vibration.hasCustomVibrationsSupport()) {
  //   Vibration.vibrate(duration: 1000);
  // } else {
  Vibration.vibrate();
  // await Future.delayed(Duration(milliseconds: 500));
  //   Vibration.vibrate();
  // }
}
