import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:flutter_pkg/src/const/strings.dart';
import 'package:flutter_pkg/src/screens/liveliness/paint.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pkg/src/controller/main_controller.dart';
import 'package:flutter_pkg/src/screens/intro_screen/intro_screen.dart';
import 'package:flutter_pkg/src/screens/liveliness/liveliness.dart';
import 'package:flutter_pkg/src/utils/img_utils.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CameraViewController extends GetxController {
  var showBoundingBoxes = true.obs;

  var cameraInitialized = false.obs;
  var _isDetected = false.obs;
  var _label = "".obs;
  var _isRunning = false.obs;
  bool get isRunning => _isRunning.value;
  set isRunning(bool v) => _isRunning(v);
  String get label => _label.value;
  set label(String l) => _label(l);
  bool get isDetected => _isDetected.value;
  set isDetected(bool v) => _isDetected(v);
  var isManualMode = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void clearDetection() {}
}

class CaptureImage extends StatefulWidget {
  const CaptureImage({Key? key, required this.type}) : super(key: key);
  final String type;
  @override
  State<CaptureImage> createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage>
    with WidgetsBindingObserver {
  late CameraController cameraController;
  bool isInitialized = false;
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  final cameraView = Get.put(CameraViewController());
  final MainController controller = Get.find();
  late TextRecognizer _textRecognizer;

  ///accelerometer values
  ///
  double x = 0, y = 0, z = 0;
  int timeStamp = 0;
  int maxDelay = 0;

  var phone = "";
  bool isCapturing = false;
  bool isRunning = false;
  bool modelReady = false;
  var imageToCapture;

  late Timer timer;
  bool timerInitialized = false;
  var value = 0;
  bool captured = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.dispose();
        cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController.value.isStreamingImages) {
          getAvailableCamera();
          
        }
        break;
      case AppLifecycleState.detached:
        cameraController.dispose();
        cameraController.stopImageStream();
        break;

      default:
    }
  }

  getAvailableCamera() async {
    loadmodel();
    List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(
        widget.type == "SelfieCapture"
            ? cameras.firstWhere(
                (element) => element.lensDirection == CameraLensDirection.front)
            : cameras.firstWhere(
                (element) => element.lensDirection == CameraLensDirection.back),
        Platform.isAndroid ? ResolutionPreset.high : ResolutionPreset.high,
        enableAudio: false);

    try {
      await cameraController.initialize();

      Get.find<MainController>().logProvider.sendLog("Init camera module.",
          funcName: "CaptureImage->getAvailableCamera()",
          label: "camera",
          errorMsg: "Init success");
      isInitialized = true;
      if (modelReady) {
        cameraController.startImageStream(runModelOnAvailableImage);
      }
    } catch (e) {
      Get.find<MainController>().logProvider.sendLog("Init tflite module.",
          funcName: "CaptureImage->getAvailableCamera()",
          label: "tflite",
          errorMsg: "Init success");
    }
    setState(() {});
  }

  resetCamera() {
    cameraController.setFocusMode(FocusMode.locked);
  }

  runModelOnAvailableImage(cameraImage) {
    if (isRunning) {
      return;
    } else {
      imageToCapture = cameraImage;
      if (modelReady) {
        if (cameraImage != null) {
          if (mounted) {
            runmodelonImage(cameraImage);
          }
        }
      }
    }
  }

  loadmodel() async {
    if (widget.type == AppStrings.FRONT) {
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);
    }
    var path =
        widget.type == AppStrings.FRONT // || widget.type == AppStrings.TILTED
            ? TModels.FRONT_MODEL
            : widget.type == AppStrings.BACK
                ? TModels.BACK_MODEL
                : widget.type == AppStrings.TILTED
                    ? 'packages/flutter_pkg/assets/tilted/1model_unquant.tflite'
                    : 'packages/flutter_pkg/assets/model_unquant.tflite';
    var labels = widget.type == AppStrings.FRONT
        ? 'packages/flutter_pkg/assets/front_new/labels.txt'
        : widget.type == AppStrings.BACK
            ? 'packages/flutter_pkg/assets/back/labels.txt'
            : widget.type == AppStrings.TILTED
                ? 'packages/flutter_pkg/assets/tilted/labels.txt'
                : 'packages/flutter_pkg/assets/labels.txt';

    try {
      await Tflite.loadModel(model: path, labels: labels);
      Get.find<MainController>().logProvider.sendLog("Init tflite module.",
          funcName: "CaptureImage->loadmodel()",
          label: "tflite",
          errorMsg: "Init success");
    } catch (e) {
      controller.logProvider.sendLog("Failed",
          funcName: "CaptureImage->loadmodel()",
          label: "EKYC ${widget.type}",
          errorMsg: "Error loading tflite ekyc model tflite");
      // print(e.toString());
    }
    modelReady = true;
    setState(() {});
  }

  //run model on image
  runmodelonImage(CameraImage img) async {
    if (mounted) {
      isRunning = true;
      if (img.planes[0].bytesPerRow > img.width) {
        if (Platform.isAndroid) {
          await cameraController.stopImageStream();

          cameraView.isManualMode(true);
        }
      }

      /// TESTING FOR UNSUPPORTED DEVICES
      // await cameraController.stopImageStream();
      // cameraView.isManualMode(true);
      // imageToCapture = img;
      // });
    }
    try {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: .1,
        asynch: true,
      );

      if (mounted) {
        isRunning = false;
      }
      var element = predictions!.first;

      if (element['confidence'] > .50) {
        if (widget.type == AppStrings.FRONT && element['label'] == "0 Front") {
          if (cameraView.label == "0 Front") {
            if (!timerInitialized) {
              // startTimer();
            }
          }
          if (cameraView.label != element['label']) {
            cameraView.isDetected = true;
            cameraView.label = element['label'];
            if (mounted) {
              cameraView.label = element['label'];
            }
          }
        } else if (widget.type == AppStrings.BACK &&
            element['label'] == "0 Back") {
          if (cameraView.label == "0 Back") {
            if (!timerInitialized) {
              // startTimer();
            }
          }
          if (cameraView.label != element['label']) {
            cameraView.isDetected = true;
            if (mounted) {
              cameraView.label = element['label'];
            }
          }
        } else if (widget.type == AppStrings.TILTED &&
            element['label'] == "1 Tilted") {
          if (cameraView.label == "1 Tilted") {
            if (!timerInitialized) {
              // startTimer();
            }
          }
          if (cameraView.label != element['label']) {
            cameraView.isDetected = true;
            if (mounted) {
              cameraView.label = element['label'];
            }
          }
        } else {
          clearDetection();
        }
      } else {
        clearDetection();
      }
    } catch (e) {
      print(e);
      controller.logProvider.sendLog("Failed",
          funcName: "CaptureImage->runmodelonImage()",
          label: "EKYC ${widget.type}",
          errorMsg:
              "${e.toString()}Error predicting image something wrong with tflite");
    }
  }

  clearDetection() {
    cameraView.label = "";
    value = 0;
    if (cameraView.label != "") {
      if (timerInitialized) {
        timerInitialized = false;
        timer.cancel();
      }
      cameraView.isDetected = false;
      if (mounted) {
        cameraView.label = "";
      }
    }
    cameraView.isDetected = false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _streamSubscriptions.add(accelerometerEvents.listen((data) {
      checkAngle(data);
    }));
    getAvailableCamera();
  }

  startTimer() {
    if (!timerInitialized) {
      timer = Timer.periodic(500.milliseconds, (t) {
        if (value > 2) {
          takePicture(imageToCapture);
          timer.cancel();
        } else {
          value++;
        }
        if (mounted) setState(() {});
      });
    }

    timerInitialized = true;
    setState(() {});
  }

  resetTimer() {
    timer.cancel();
    timerInitialized = false;
    value = 0;
  }

  checkAngle(AccelerometerEvent data) {
    if (widget.type == AppStrings.TILTED) {
      if (kDebugMode) Get.log("TILTED");
      if (data.x >= -1 &&
          data.x <= 1 &&
          data.y >= 4.5 &&
          data.y <= 7.5 &&
          data.z >= 6.5 &&
          data.z <= 9) {
      } else {
        clearDetection();
        x = data.x;
        y = data.y;
        z = data.z;

        if (kDebugMode) Get.log("CLEAR DETECTION");
      }
    } else if (data.x >= -1.0 &&
        data.x <= 1.0 &&
        data.y >= 0.0 &&
        data.y <= 3.0 &&
        data.z >= 7 &&
        data.z <= 11.0) {
      if (timerInitialized) {
        if (kDebugMode) Get.log(timer.tick.toString());
      }
    } else {
      clearDetection();
    }
  }

  Widget cameraWidget(context) {
    var camera = cameraController.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(cameraController),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();

    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  /// Manual Mode
  takePictureManualMode() async {
    var file = await cameraController.takePicture();

    // var cameras = await availableCameras();
    // cameraController.dispose();
    // cameraController = CameraController(
    //     widget.type == "SelfieCapture"
    //         ? cameras.firstWhere(
    //             (element) => element.lensDirection == CameraLensDirection.front)
    //         : cameras.firstWhere(
    //             (element) => element.lensDirection == CameraLensDirection.back),
    //     ResolutionPreset.high,
    //     enableAudio: false);
    // print(file.path);
    // print(file.path);
    var image = await cropImage(file.path);
    Directory appDocDir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getTemporaryDirectory();

    String appDocPath = appDocDir.path;
    var fl = File(
        "${appDocPath + "/" + DateTime.now().millisecondsSinceEpoch.toString()}.png");

    await fl.writeAsBytes(image);
    // showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //           content: Image.file(File(fl.path)),
    //         ));
    var prediction = await Tflite.runModelOnImage(path: file.path);
    if (prediction != null) {
      if (prediction.isNotEmpty &&
          prediction.first['confidence'] > .5 &&
          !prediction.first['label'].toString().contains('Error')) {
        widget.type == AppStrings.FRONT
            ? controller.frontImage(fl.path)
            : widget.type == AppStrings.BACK
                ? controller.backImage(fl.path)
                : widget.type == AppStrings.TILTED
                    ? controller.tilted(fl.path)
                    : controller.selfie(fl.path);
        controller.nextPage();
        Get.delete<CameraViewController>();
      } else {
        widget.type == AppStrings.FRONT
            ? controller.frontImage(fl.path)
            : widget.type == AppStrings.BACK
                ? controller.backImage(fl.path)
                : widget.type == AppStrings.TILTED
                    ? controller.tilted(fl.path)
                    : controller.selfie(fl.path);
        controller.nextPage();
        Get.delete<CameraViewController>();
        // showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //           content: Container(
        //             color: Colors.red,
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: const [
        //                 Text("Failed to detect document"),
        //                 Text("Try again")
        //               ],
        //             ),
        //           ),
        //         ));
        // controller.nextPage();
        // Get.delete<CameraViewController>();
      }
    } else {
      // showDialog(
      //     context: context,
      //     builder: (_) => AlertDialog(
      //           content: Container(
      //             color: Colors.red,
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Text("Failed to detect document"),
      //               ],
      //             ),
      //           ),
      //         ));
    }
  }

  /// TAKE PICTURE ON IMAGESTREAM
  takePicture(CameraImage cameraImage) async {
    await cameraController.stopImageStream();
    if (!captured) {
      if (cameraImage.planes[0].bytesPerRow == cameraImage.width) {
        var image = cameraImage.format.group == ImageFormatGroup.yuv420
            ? await convertYUV420toImageColor(cameraImage)
            : convertBGRA8888(cameraImage);
        Directory appDocDir = await getTemporaryDirectory();
        String appDocPath = appDocDir.path;
        controller.logProvider.sendLog("Success",
            funcName: "CaptureImage->capture()",
            label: "EKYC ${widget.type}",
            errorMsg: "Successfully captured ${widget.type} image.");
        var file = File(
            "${appDocPath + "/" + DateTime.now().millisecondsSinceEpoch.toString()}.png");
        try {
          await file.writeAsBytes(image);
        } catch (e) {
          Get.log(e.toString());
        }
        widget.type == AppStrings.FRONT
            ? controller.frontImage(file.path)
            : widget.type == AppStrings.BACK
                ? controller.backImage(file.path)
                : widget.type == AppStrings.TILTED
                    ? controller.tilted(file.path)
                    : controller.selfie(file.path);
      } else {
        cameraView.showBoundingBoxes(false);
        await Future.delayed(const Duration(milliseconds: 30));
        var path = (await FlutterNativeScreenshot.takeScreenshot())!;
        var filepath = await cropIosImage(path);
        Directory appDocDir = await getTemporaryDirectory();
        String appDocPath = appDocDir.path;
        controller.logProvider.sendLog("Success",
            funcName: "CaptureImage->capture()",
            label: "EKYC ${widget.type}",
            errorMsg: "Successfully captured ${widget.type} image.");
        var file = File(
            "${appDocPath + "/" + DateTime.now().millisecondsSinceEpoch.toString()}.png");
        try {
          await file.writeAsBytes(filepath);
        } catch (e) {
          Get.log(e.toString());
        }

        // showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //             content: Container(
        //           height: 200,
        //           width: 200,
        //           child: Image.memory(filepath),
        //         )));

        widget.type == AppStrings.FRONT
            ? controller.frontImage(file.path)
            : widget.type == AppStrings.BACK
                ? controller.backImage(file.path)
                : widget.type == AppStrings.TILTED
                    ? controller.tilted(file.path)
                    : controller.selfie(file.path);
        // print(path);
        // showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //             content: Container(
        //           height: 200,
        //           width: 200,
        //           child: Image.file(File(path)),
        //         )));
      }
      // print(file.path + "CAPTURE");

      // timer.cancel();
      vibrate();

      controller.nextPage();
      Get.delete<CameraViewController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        resetCamera();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          width: double.infinity,
          child: Stack(alignment: Alignment.center, children: [
            if (isInitialized)

              ///TODO : CODE FOR PREVIEWING CENTER PART ONLY
              ///

              // Center(
              //   child: AspectRatio(
              //     aspectRatio: 1 / .6,
              //     child: ClipRect(
              //       child: Transform.scale(
              //         scale: cameraController.value.aspectRatio / .6,
              //         child: Center(
              //           child: CameraPreview(cameraController),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              ...[
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: CameraPreview(
                    cameraController,
                  ),
                ),
              ),
              Obx(
                () => cameraView.showBoundingBoxes.isFalse
                    ? const SizedBox()
                    : widget.type == AppStrings.TILTED
                        ? Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, .001)
                              ..rotateX(-30 / 180 * pi),
                            alignment: Alignment.center,
                            child: BoundingBox(
                              hasChild: false,
                              color: phone == 'portrait' || phone == '45 degree'
                                  ? Colors.green
                                  : cameraView.label != ""
                                      ? Colors.green
                                      : Colors.white,
                            ),
                          )
                        : BoundingBox(
                            hasChild: false,
                            color: phone == 'portrait' || phone == '45 degree'
                                ? Colors.green
                                : cameraView.label != ""
                                    ? Colors.green
                                    : Colors.white,
                          ),
              ),
              // Obx(
              //   () => !cameraView.isDetected
              //       ? Positioned(
              //           bottom: 60.h,
              //           child: Container(
              //             width: double.infinity,
              //             height: Get.height,
              //             alignment: Alignment.center,
              //             child: CustomPaint(
              //               painter: OvalPainter(),
              //               child: SizedBox(
              //                 height: MediaQuery.of(context).size.height / 2,
              //                 width: MediaQuery.of(context).size.width / 1.2,
              //               ),
              //             ),
              //           ),
              //         )
              //       : SizedBox(),
              // ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: REdgeInsets.only(
                      left: 30, right: 30, top: 24, bottom: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))
                        .r,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.type == AppStrings.BACK
                              ? """Capture Back side of the Card"""
                              : widget.type == AppStrings.TILTED
                                  ? """Capture Oblique-\n45 degree of the Card"""
                                  : """Capture Front side\nof the Card""",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 20.sp, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          """Start by positioning the front of our ID Card in the frame. Use a well-lit area and a simple dark background.""",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color.fromRGBO(0, 0, 0, 0.7)),
                        )
                      ]),
                ),
              ),
              Obx(() => cameraView.showBoundingBoxes.isFalse
                  ? SizedBox()
                  : cameraView.isDetected || cameraView.isManualMode.isTrue
                      ? Positioned(
                          bottom: 160.h,
                          left: 100.w,
                          right: 100.w,
                          child: InkWell(
                            onTap: () {
                              // if (imageToCapture != null)
                              if (cameraView.isManualMode.isTrue) {
                                takePictureManualMode();
                              } else {
                                takePicture(imageToCapture);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // color: Colors.red,
                              height: 100.w,
                              width: 100.w,
                              child: CustomPaint(
                                  painter: CirclePaint(radius: 26.r)),
                            ),
                          ),
                        )
                      : const SizedBox()),

              Positioned(
                  top: 60.h,
                  right: 20.w,
                  child: Obx(
                    () => CloseButton(
                      onPressed: controller.currentPage > 3
                          ? () {
                              controller.previousPage();
                            }
                          : null,
                      color: Colors.white,
                    ),
                  )),
              // BoundingBox(widget: widget, label: label, phone: phone),
            ]
          ]),
        ),
      ),
    );
  }
}
