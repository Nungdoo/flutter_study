import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Example2'),),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              // 같은 detail 태크의 다른 Hero 위젯과 연결됨
              Hero(tag: 'detail', child: Icon(Icons.cake, size: 150,),)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}