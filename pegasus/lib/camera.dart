import 'dart:async';
import 'dart:convert';
import 'dart:developer';
// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late final WebViewController controller;

  // late Timer _clockTimer;

  Future<void> fetchPiStatus() async {
    final response = await http.get(
      Uri.parse(''),
    );
    if (response.statusCode == 200) {
      // return PiStatus.fromJson(jsonDecode(response.body));
      final data = jsonDecode(response.body);
      if(data['detected']) {
        log(data);
      }
    } else {
      throw Exception('Failed to fetch Pi status');
    }
  }

  @override
  void dispose() {
    // controller.clearCache();
    // controller.clearLocalStorage();
    // _clockTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(''),
      );
    
      // _clockTimer = Timer.periodic(Duration(seconds: 1), (timer) {fetchPiStatus();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Camera'),
      ),
      body: Column(
        spacing: 0.5.dp,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 1.5.dp,
            child: WebViewWidget(controller: controller)
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 0.1.dp,
            children: [
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: CircleBorder()),
                child: Icon(Icons.keyboard_double_arrow_left_rounded, color: Colors.white, size: 30.sp)
              ),
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: CircleBorder()),
                child: Icon(Icons.stop_circle_rounded, color: Colors.white, size: 35.sp,)
              ),
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: CircleBorder()),
                child: Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.white, size: 30.sp)
              ),
            ],
          )
        ],
      ),
    );
  }
}
