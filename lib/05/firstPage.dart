import 'package:flutter/material.dart';
import './animalItem.dart';

class FirstApp extends StatelessWidget {
  final List<Animal>? list;

  // list를 매개변수로 입력받는 생성자
  FirstApp({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          // itemBuilder는 BuildContext와 int를 반환
          // BuildContext는 위젯 트리에서 위젯의 위치를 알려줌 -> context
          // int는 아이템의 순번을 의미함 -> position
          child: ListView.builder(itemBuilder: (context, position) {
            return Card(
              child: Row(
                children: <Widget>[
                  Image.asset(
                    list![position].imagePath!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain
                  ),
                  Text(list![position].animalName!)
                ],
              )
            );
          },
          // 아이템 개수만큼만 스크롤 할 수 있게 제한
          itemCount: list!.length,)
        )
      )
    );
  }
}

