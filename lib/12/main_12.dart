import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io'; // Platform 객체를 이용하기 위함
import 'package:flutter/services.dart'; // MethodChannel을 이용하기 위함

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        home: CupertinoNativeApp(),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NativeApp()
      );
    }
  }
}

class CupertinoNativeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NativeApp();
}

class NativeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NativeApp();
}

class _NativeApp extends State<NativeApp> {
  // 안드로이드와의 통신 채널
  // 어떤 통신을 할 것인지 키값을 넘김
  static const platform = const MethodChannel('com.flutter.dev/info');
  // 전달받은 기기 정보를 저장
  String _deviceInfo = 'Unknown info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Native 통신 예제'),
      ),
      body: Container(
        child: Center(
          child: Text(
            _deviceInfo,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getDeviceInfo();
        },
        child: Icon(Icons.get_app),
      ),
    );
  }

  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try {
      // 메서드 채널로 연결된 안드로이드에서 네이티브 API 호출
      // getDeviceInfo : 안드로이드 네이티브 소스에서 호출할 함수 이름
      final String result = await platform.invokeMethod('getDeviceInfo');
      deviceInfo = 'Device info : $result';
    } on PlatformException catch (e) {
      deviceInfo = 'Failed to get Device info : ${e.message}';
    }

    setState(() {
      _deviceInfo = deviceInfo;
    });
  }
}