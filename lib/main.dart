import 'package:flutter/material.dart';

void main() {
  // 플러터 앱 시작
  // 플러터 앱을 시작하면서 화면에 표시할 위젯 전달
  runApp(MyApp());
}

// StatelessWidget : 상태를 연결할 필요가 없는 위젯 (위젯의 상태를 감시할 필요 X)
// <-> StatefulWidget
// StatefulWidget은 화면을 출력하려면 State 클래스가 필요함
// MyApp 클래스가 화면을 주시하다가 상태가 변경되면 이를 감지하고 _MyApp 클래스가 화면을 갱신함
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  var switchValue = false;

  // build 함수 재정의, 어떤 위젯을 만들건지 정의
  @override
  Widget build(BuildContext context) {
    // runApp()을 이용해 클래스를 실행할 때는 MaterialApp() 함수가 반환되어야 함
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.light(),
      // home : 첫 화면에 어떤 내용을 표시할지 결정
      home: Scaffold(
        body: Center(
          child: Switch(
            value: switchValue,
            onChanged: (value) {
              // 변수값이 바뀜을 앱에 알려 화면을 갱신시킴
              // 화면의 값을 바꾸려면 setState() 함수 안에서 해야 함
              setState(() {
                print(value);
                switchValue = value;
              });
            },
          ),
        ),
      )
    );
  }
}

