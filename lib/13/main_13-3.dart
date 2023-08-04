import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'memoPage.dart';

void main() async {
  /*
  Firebase.initializeApp()는 Firebase를 초기화하기 위해 네이티브 코드를 호출해야 함
  네이티브 코드를 호출하려면 플랫폼 채널을 사용해야 함
  플랫폼 채널을 비동기적으로 작동하므로,
  WidgetsFlutterBinding.ensureInitialized()를 통해 플랫폼 채널의 위젯 바인딩을 보장해야 함
  */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoPage(),
    );
  }
}