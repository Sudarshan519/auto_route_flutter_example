import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<List<int>> convertCameraImageToImage(CameraImage image) async {
  final int width = image.width;
  final int height = image.height;

  // Convert the camera image to a list of bytes.
  final List<int> bytes = [];
  for (Plane plane in image.planes) {
    bytes.addAll(plane.bytes);
  }
  final pixels = Uint8List.fromList(bytes);
  final completer = Completer<ui.Image>();

  ui.decodeImageFromPixels(
    pixels,
    width,
    height,
    ui.PixelFormat.bgra8888,
    (ui.Image image) => completer.complete(image),
  );
  ui.Image im = await completer.future;
  imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);

  List<int> png = pngEncoder.encode(im as imglib.Image);
  return png;
}
// imglib.Image convertYUV420ToImage(CameraImage cameraImage) {
//   final width = cameraImage.width;
//   final height = cameraImage.height;

//   final yRowStride = cameraImage.planes[0].bytesPerRow;
//   final uvRowStride = cameraImage.planes[1].bytesPerRow;
//   final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

//   final image = imglib.Image(width, height);

//   for (var w = 0; w < width; w++) {
//     for (var h = 0; h < height; h++) {
//       final uvIndex =
//           uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
//       final index = h * width + w;
//       final yIndex = h * yRowStride + w;

//       final y = cameraImage.planes[0].bytes[yIndex];
//       final u = cameraImage.planes[1].bytes[uvIndex];
//       final v = cameraImage.planes[2].bytes[uvIndex];

//       image.data[index] = yuv2rgb(y, u, v);
//     }
//   }
//   return image;
// }

// int yuv2rgb(int y, int u, int v) {
//   // Convert yuv pixel to rgb
//   var r = (y + v * 1436 / 1024 - 179).round();
//   var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
//   var b = (y + u * 1814 / 1024 - 227).round();

//   // Clipping RGB values to be inside boundaries [ 0 , 255 ]
//   r = r.clamp(0, 255);
//   g = g.clamp(0, 255);
//   b = b.clamp(0, 255);

//   return 0xff000000 | ((b << 16) & 0xff0000) | ((g << 8) & 0xff00) | (r & 0xff);
// }

// Future<List<int>> convertImageToPng(CameraImage image) async {
//   imglib.Image? img;
//   if (image.format.group == ImageFormatGroup.yuv420) {
//     img = convertYUV420toImageColor(image);
//   } else if (image.format.group == ImageFormatGroup.bgra8888) {
//     img = _convertBGRA8888(image);
//   }

//   imglib.PngEncoder pngEncoder = imglib.PngEncoder();

//   // Convert to png
//   List<int> png = pngEncoder.encodeImage(img!);
//   return png;
// }

// CameraImage BGRA8888 -> PNG
// Color
convertBGRA8888(CameraImage image) {
  var img = imglib.Image.fromBytes(
      width: image.width,
      height: image.height,
      bytes: image.planes[0].bytes.buffer,
      format: imglib.Format.float32);
  imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);

  List<int> png = pngEncoder.encode(img);
  return png;
}

const shift = (0xFF << 24);
convertYUV420toImageColor(CameraImage image, {bool rotate = false}) async {
  final int width = image.width;
  final int height = image.height;
  var aspectRatio = width / height;
  try {
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(height: height, width: width); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride! * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // img.data[index] = shift | (b << 16) | (g << 8) | r;

        img.setPixelRgb(x, y, r, g, b);
      }
    }

    if (Platform.isAndroid) {
      img = imglib.copyRotate(img, angle: rotate ? -90 : 90);
      if (rotate) {
        img = imglib.copyResize(img, width: 360, height: 640);
      } else {}
    }

    ///trim rect
    if (!rotate) {
      var x = 20 + 20 * 1 / aspectRatio;
      var y = 150 + 150 * aspectRatio;
      var width = 420 + 420 * aspectRatio;
      var height = 300 + 300 * 1 / aspectRatio;
      img = imglib.copyCrop(img,
          x: x.toInt(),
          y: y.toInt(),
          width: width.toInt(),
          height: height.toInt());
      img = imglib.copyResize(img, width: img.width, height: img.height);
      //  img = imglib.copyCrop(img, x: 30, y: 180, width: 425, height: 300);
    } else {
      img = imglib.flipHorizontal(img);
    }

    imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);

    List<int> png = pngEncoder.encode(img);
    // muteYUVProcessing = false;
    return (png);
  } catch (e) {
    // print(">>>>>>>>>>>> ERROR:" + e.toString());
  }
  // return null;
}

cropImage(String path) async {
  // imglib.decodeJpg(file.readAsBytesSync());
  var img = await imglib.decodeImageFile(path);
  final int imgwidth = img!.width;
  final int imgheight = img.height;
  var aspectRatio = imgwidth / imgheight;
  var x = 20 + 20 * 1 / aspectRatio;
  var y = img.height / 2 * aspectRatio;
  var width = 420 + 420 * aspectRatio;
  var height = 300 * 1 / aspectRatio;
  img = imglib.copyCrop(img,
      x: x.toInt(), y: y.toInt(), width: width.toInt(), height: height.toInt());

  img = imglib.copyResize(img,
      width: img.width ~/ 1.2, height: img.height ~/ 1.2);
  // img = imglib.copyResize(img, width: 400, height: 200);
  imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);

  List<int> png = pngEncoder.encode(img);

  return png;
}

cropSelfie(String path) async {
  // imglib.decodeJpg(file.readAsBytesSync());
  var img = await imglib.decodeImageFile(path);
  final int imgwidth = img!.width;
  final int imgheight = img.height;

  var aspectRatio = imgwidth / imgheight;
  var x = 10 + 10 * 1 / aspectRatio;
  var y = img.height / 1.8 * aspectRatio;
  var width = img.width;
  var height = img.height / 1.5;
  img = imglib.copyCrop(img,
      x: x.toInt(), y: y.toInt(), width: width.toInt(), height: height.toInt());
  // img = imglib.copyResize(img,
  //     width: img.width ~/ 1.5, height: img.height ~/ 1.5);
  // img = imglib.copyResize(img, width: 400, height: 200);
  imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);

  List<int> png = pngEncoder.encode(img);

  return png;
}

cropIosImage(String path) async {
  // imglib.decodeJpg(file.readAsBytesSync());
  var img = await imglib.decodeImageFile(path);
  final int imgwidth = img!.width;
  final int imgheight = img.height;

  var aspectRatio = imgwidth / imgheight;
  var x = 10 + 10 * 1 / aspectRatio;
  var y = img.height / 1.8 * aspectRatio;
  var width = img.width;
  var height = img.height / 2.2;
  img = imglib.copyCrop(img,
      x: x.toInt(), y: y.toInt(), width: width.toInt(), height: height.toInt());
  // img = imglib.copyResize(img,
  //     width: img.width ~/ 1.5, height: img.height ~/ 1.5);
  // img = imglib.copyResize(img, width: 400, height: 200);
  imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);

  List<int> png = pngEncoder.encode(img);

  return png;
}

flipImage(String path) async {
  var img = await imglib.decodeImageFile(path);
  img = imglib.flipHorizontal(img!);
  imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);
  img = imglib.copyResize(img, width: 360, height: 640);
  List<int> png = pngEncoder.encode(img);
  return png;
}

Image resizeImage(img) {
  img = imglib.copyResize(img, width: 720, height: 1280);
  return img;
}
