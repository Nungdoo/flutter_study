import 'package:flutter/material.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subpage Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: FirstPage()

      // 처음 앱을 시작했을 때 보여줄 경로
      initialRoute: '/',

      // String : Widget 형태로 경로 선언
      routes: {
        '/': (context) => FirstPage(),
        '/second': (context) => SecondPage()
      },
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Page Main'),
      ),
      body: Container(
        child: Center(
          child: Text('첫 번째 페이지'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator : 스택을 이용해 페이지를 관리할 때 사용하는 클래스
          // of(context) : 현재 페이지를 나타냄
          // push : 스택에 페이지를 쌓음
          // -> 현재 페이지 위에 SecondPage를 쌓음
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage()));

          // pushNamed() : routes에 선언한 경로를 이용해 페이지 이동
          Navigator.of(context).pushNamed('/second');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // 현재 페이지 종료
              // Navigator.of(context).pop();

              Navigator.of(context).pushNamed('/');
            },
            child: Text('돌아가기'),
          ),
        ),
      )
    );
  }
}