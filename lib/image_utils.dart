import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

Image resizeImage(img) {
  img = imglib.copyResize(img, width: 720, height: 1280);
  return img;
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
  var file = File((await getTemporaryDirectory()).path);
  var fl = File(
      "${file.path + "/" + DateTime.now().millisecondsSinceEpoch.toString()}.png");
  await fl.writeAsBytes(png);
  return fl.path;
}

Future<imglib.Image?> getImage(String path) async {
  var img = await imglib.decodeImageFile(path);
  return img;
}
