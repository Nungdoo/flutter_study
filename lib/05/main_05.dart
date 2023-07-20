import 'package:first_flutter_app/05/firstPage.dart';
import 'package:first_flutter_app/05/secondPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Widget Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyHomePageState(),
    );
  }
}

class MyHomePageState extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

// 탭 이동 애니메이션을 위해 SingleTickerProviderStateMixin 클래스를 추가 상속
class _MyHomePageState extends State<MyHomePageState>
  with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    // length : 몇 개의 탭
    // vsync : 탭이 이동했을 때 호출되는 콜백 함수를 어디서 처리할지
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabBar Example'),
      ),
      body: TabBarView(
        children: <Widget>[FirstApp(), SecondApp()],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(icon: Icon(Icons.looks_one, color: Colors.blue,),),
          Tab(icon: Icon(Icons.looks_two, color: Colors.blue,),),
        ],
        controller: controller,
      ),
    );
  }

  // Stateful이 마지막에 호출하는 함수
  // Tab controller는 애니메이션을 이용하여 dispose를 호출해야 메모리 누수를 막을 수 있음
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}

