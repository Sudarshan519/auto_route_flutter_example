import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

@RoutePage()
class MlVisionPage extends StatefulWidget {
  const MlVisionPage({super.key});

  @override
  State<MlVisionPage> createState() => _MlVisionPageState();
}

class _MlVisionPageState extends State<MlVisionPage> {
  var data = "";

  @override
  Widget build(BuildContext context) {
    readData() async {
      final mlvision = await FlutterMobileVision.read(
          multiple: false, preview: Size(720, 1080), waitTap: true);
      data = "";
      setState(() {
        for (var element in mlvision) {
          data = data + element.value;
          print(element.language);
        }

        // data = mlvision.toString();
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  readData();
                },
                child: Text("READ")),
            Text(data)
          ],
        ),
      ),
    );
  }
}
