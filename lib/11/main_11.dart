import 'package:flutter/material.dart';
import 'people.dart';
import 'secondPage.dart';
import 'sliverPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimationApp(),
    );
  }
}

class AnimationApp extends StatefulWidget {
    @override
  State<StatefulWidget> createState() => _AnimationApp();
}

class _AnimationApp extends State<AnimationApp> {
  List<People> peoples = new List.empty(growable: true);
  Color weightColor = Colors.blue;
  int current = 0;
  double _opacity = 1;

  @override
  void initState() {
    peoples.add(People('피카츄', 180, 92));
    peoples.add(People('라이츄', 170, 82));
    peoples.add(People('파이리', 160, 52));
    peoples.add(People('꼬부기', 150, 62));
    peoples.add(People('버터풀', 140, 70));
    peoples.add(People('야도란', 130, 40));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(width: 100, child: Text('이름 : ${peoples[current].name}'),),
                      AnimatedContainer(
                        duration: Duration(seconds: 2),
                        curve: Curves.bounceIn,
                        color: Colors.amber,
                        width: 50,
                        height: peoples[current].height,
                        child: Text(
                          '키 ${peoples[current].height}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: 2),
                        curve: Curves.easeInCubic,
                        color: weightColor,
                        width: 50,
                        height: peoples[current].weight,
                        child: Text(
                          '몸무게 ${peoples[current].weight}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(seconds: 2),
                        curve: Curves.linear,
                        color: Colors.pinkAccent,
                        width: 50,
                        height: peoples[current].bmi,
                        child: Text(
                          'bmi ${peoples[current].bmi}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (current < peoples.length - 1) {
                      current++;
                    }
                    _changeWeightColor(peoples[current].weight);
                  });
                },
                child: Text('다음'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (current > 0) {
                      current--;
                    }
                    _changeWeightColor(peoples[current].weight);
                  });
                },
                child: Text('이전'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _opacity == 1 ? _opacity = 0 : _opacity = 1;
                  });
                },
                child: Text('사라지기'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage()));
                  });
                },
                child: SizedBox(
                  width: 200,
                  child: Row(
                    children: <Widget>[
                      // 같은 detail 태크의 다른 Hero 위젯과 연결됨
                      Hero(tag: 'detail', child: Icon(Icons.cake),),
                      Text('이동하기')
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SliverPage()));
                },
                child: Text('페이지 이동'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeWeightColor (double weight) {
    if (weight < 40) {
      weightColor = Colors.blueAccent;
    } else if (weight < 60) {
      weightColor = Colors.indigo;
    } else if (weight < 80) {
      weightColor = Colors.orange;
    } else {
      weightColor = Colors.red;
    }
  }
}