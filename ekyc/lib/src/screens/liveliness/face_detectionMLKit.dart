import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/src/screens/liveliness/paint.dart';
import 'package:flutter_pkg/src/utils/img_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:path_provider/path_provider.dart';

class SeflieController extends GetxController {
  var faceDetected = false.obs;
}

class FaceDetectionMlKit extends StatefulWidget {
  const FaceDetectionMlKit({Key? key}) : super(key: key);

  @override
  State<FaceDetectionMlKit> createState() => _FaceDetectionMlKitState();
}

class _FaceDetectionMlKitState extends State<FaceDetectionMlKit>
    with WidgetsBindingObserver {
  final SeflieController selfieController = Get.put(SeflieController());
  var cameras = [];
  var cameraInitilized = false;
  var loading = false;
  var captured = false;
  // var faceDetected = false;
  var isRunning = false;
  var isNavigating = false;
  var cameraImage;
  var isManualMode = false;
  var path;
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
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  @override
  void initState() {
    super.initState();
    initCameraModule();
  }

  initCameraModule() async {
    try {
      cameras = await availableCameras();
      setState(() {});
      var cameraDescirption = cameras[1];
      controller = CameraController(cameraDescirption, ResolutionPreset.high,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.bgra8888);
      await controller.initialize().then((_) {
        setState(() {
          cameraInitilized = true;
        });
        controller.startImageStream(runMLModel);
      });
    } catch (e) {
      Get.find<MainController>().logProvider.sendLog("Failed",
          funcName: "CameraPage->initCameraModule()",
          label: "EKYC Face",
          errorMsg: "Error loading device cameras");
    }
  }

  void checkAngle(AccelerometerEvent data) {
    if (x == data.x.round() &&
        y == data.y.round() &&
        z == data.z.round() &&
        z > .5 &&
        y > 8 &&
        x < 1) {
      if (!isNavigating) {
        if ((blinkTimeStamp - faceTimeStamp) > 100) {
          isNavigating = true;
          vibrate();
          Future.delayed(0.seconds, () {
            mainController.nextPage();
          });
        }
      }
    } else {
      x = data.x.round();
      y = data.y.round();
      z = data.z.round();
      clearBlinks();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  takePicture(cameraImage) async {
    loading = true;
    captured = true;

    if (cameraImage.planes[0].bytesPerRow == cameraImage.width) {
      Get.find<MainController>().logProvider.sendLog(
          "Front picture captured success.",
          funcName: "FaceDetectionPage -> takePicture()",
          label: "EKYC Face",
          errorMsg: "Front picture captured success");
      if (mounted) setState(() {});
      var image = await convertYUV420toImageColor(cameraImage, rotate: true);
      Directory appDocDir = await getTemporaryDirectory();
      String appDocPath = appDocDir.path;

      var file = File(
          "${appDocPath + "/" + DateTime.now().millisecondsSinceEpoch.toString()}.png");
      await file.writeAsBytes(image);
      path = file.path;
      mainController.selfie(path);
    } else {
      selfieController.faceDetected(false);
      await controller.stopImageStream();

      // setState(() {
      //   faceDetected = false;
      // });
      await Future.delayed(const Duration(milliseconds: 25));

      var path = (await FlutterNativeScreenshot.takeScreenshot());
      Directory appDocDir = await getTemporaryDirectory();
      String appDocPath = appDocDir.path;

      var file = File(
          "${appDocPath + "/" + DateTime.now().millisecondsSinceEpoch.toString()}.png");

      var img = await cropSelfie(path ?? "");
      await file.writeAsBytes(img);
      var p = file.path;
      mainController.selfie(p);
      // print(path);
      // var file = cropImage(path);
      // showDialog(
      //     context: context,
      //     builder: (_) => AlertDialog(
      //             content: Container(
      //           height: 200,
      //           width: 200,
      //           child: Image.file(File(path)),
      //         )));
    }

    Future.delayed(Duration.zero, () {
      loading = false;
      if (mounted) setState(() {});
    });
    if (!isNavigating) mainController.nextPage();
  }

  void takePictureManual() async {
    loading = true;
    captured = true;
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
    print(newfile.lengthSync() / (1024 * 1024));
    // resizeImage(image);
    path = newfile.path;
    mainController.selfie(path);

    Future.delayed(Duration.zero, () {
      loading = false;
      if (mounted) setState(() {});
    });
    if (!isNavigating) mainController.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    // isManualMode = true;
    return Scaffold(
      backgroundColor: Colors.black,
      body: !cameraInitilized
          ? CircularProgressIndicator()
          : Obx(
              () => Stack(
                children: [
                  if (cameraInitilized) //Center(child: CameraPreview(controller)),
                    OverflowBox(
                        maxWidth: double.infinity,
                        alignment: Alignment.center,
                        child: CameraPreview(controller)),
                  if (selfieController.faceDetected.isTrue)
                    Container(
                      color: Colors.black54.withOpacity(.5),
                    ),
                  if (selfieController.faceDetected.isTrue || isManualMode) ...[
                    Positioned(
                      bottom: 30.h,
                      left: 80.w,
                      right: 80.w,
                      child: InkWell(
                        onTap: () {
                          if (isManualMode) {
                            takePictureManual();
                          } else {
                            takePicture(cameraImage);
                          }
                        },
                        child: Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          height: 80.w,
                          width: 80.w,
                          child: CustomPaint(painter: CirclePaint()),
                        ),
                      ),
                    ),

                    // if (faceDetected)
                    Center(
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.6),
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  MediaQuery.of(context).size.height / 2),
                            ),
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 2,
                          child: OverflowBox(
                              maxWidth: double.infinity,
                              alignment: Alignment.center,
                              child: Transform.scale(
                                  scale: controller.value.aspectRatio / .874,
                                  child: CameraPreview(controller))),
                        ),
                      ),
                    ),

                    // if (faceDetected)
                    Positioned(
                        bottom: 120.h,
                        left: 40.w,
                        right: 40.w,
                        child: Text(
                          "Position your face in oval",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white),
                        )),

                    Container(
                      width: double.infinity,
                      height: Get.height,
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: OvalPainter(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width / 1.2,
                        ),
                      ),
                    ),
                  ] else if (!selfieController.faceDetected.isTrue)
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: const Color(0xff393939),
                          width: double.infinity,
                          alignment: Alignment.center,
                          height: 100,
                          child: Text(
                            "Position your face in the frame",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                          ),
                        )),
                  if (!selfieController.faceDetected.isTrue)
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  Positioned(
                      top: 40.h,
                      right: 20.w,
                      child: Obx(
                        () => CloseButton(
                          onPressed: mainController.currentPage > 3
                              ? () {
                                  mainController.previousPage();
                                }
                              : null,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
    );
  }

  runMLModel(CameraImage image) async {
    if (isRunning) return;
    isRunning = true;
    if (image.planes.first.bytesPerRow != image.width && Platform.isAndroid) {
      await controller.stopImageStream();
      isManualMode = true;
      setState(() {});
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
    if (faces.isNotEmpty) {
      for (Face face in faces) {
        blinkTimeStamp = DateTime.now().millisecondsSinceEpoch;
        if (face.leftEyeOpenProbability != null) {
          if ((face.leftEyeOpenProbability ?? 99) < .5) {
          } else {
            cameraImage = image;
            faceTimeStamp = DateTime.now().millisecondsSinceEpoch;
            if (selfieController.faceDetected.value != true &&
                face.leftEyeOpenProbability! > .2) {
              if (mounted) {
                selfieController.faceDetected(true);
              }
            }

            if (kDebugMode) {
              print(image.format.group);
            }
          }
        }
      }
    } else {
      if (selfieController.faceDetected.value != false) {
        selfieController.faceDetected(false);
        //
        // setState(() {
        //   faceDetected = false;
        // });
      }
    }
  }

  void clearBlinks() {
    selfieController.faceDetected(false);
    // faceDetected = false;
  }
}

void vibrate() async {
  Vibration.vibrate();
}
