import './firstPage.dart';
import './secondPage.dart';
import 'package:flutter/material.dart';
import './animalItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'ListView Example';

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
  // growable : 이 리스트가 가변적으로 증가할 수 있다는 것을 의미
  List<Animal> animalList = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    // length : 몇 개의 탭
    // vsync : 탭이 이동했을 때 호출되는 콜백 함수를 어디서 처리할지
    controller = TabController(length: 2, vsync: this);

    animalList.add(Animal(animalName: "벌", kind: "곤충", imagePath: "image/bee.png"));
    animalList.add(Animal(animalName: "고양이", kind: "포유류", imagePath: "image/cat.png"));
    animalList.add(Animal(animalName: "젖소", kind: "포유류", imagePath: "image/cow.png"));
    animalList.add(Animal(animalName: "강아지", kind: "포유류", imagePath: "image/dog.png"));
    animalList.add(Animal(animalName: "여우", kind: "포유류", imagePath: "image/fox.png"));
    animalList.add(Animal(animalName: "원숭이", kind: "영장류", imagePath: "image/monkey.png"));
    animalList.add(Animal(animalName: "돼지", kind: "포유류", imagePath: "image/pig.png"));
    animalList.add(Animal(animalName: "늑대", kind: "포유류", imagePath: "image/wolf.png"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView Example'),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[FirstApp(list: animalList), SecondApp(list: animalList)],
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

