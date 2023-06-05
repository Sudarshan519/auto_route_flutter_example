import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DownloadModel {
  var frontModelUrl = "";
  var tiltedModelUrl = "";
  var backModelUrl = "";

  
  Future<File> downloadFile(String url, String filename) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir =
          // await getTemporaryDirectory();
          (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/$filename');
      await file.writeAsBytes(bytes);
      // print('downloaded file path = ${file.path}');
      return file;
    } catch (error) {
      // print('pdf downloading error = $error');
      return File('');
    }
  }
}
