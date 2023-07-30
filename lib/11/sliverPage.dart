import 'package:flutter/material.dart';
import 'dart:math' as math;

class SliverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliverPage();
}

class _SliverPage extends State<SliverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView( // Sliver를 사용해 사용자 정의 스크롤 효과를 만드는 위젯
        slivers: <Widget>[
          SliverAppBar( // 1) 확장 앱 바
            expandedHeight: 150.0, // 앱바의 높이 설정
            // SliverAppBar 공간에 어떤 위젯을 만들지 설정
            flexibleSpace: FlexibleSpaceBar( // Material 디자인 앱바를 확장하거나 축소, 스트레칭 해줌
              title: Text('Sliver Example'),
              background: Image.asset('image/flutter_logo.png'),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            pinned: true, // 앱바가 사라지지 않고 최소의 크기로 고정되도록 함
          ),
          SliverPersistentHeader(
            delegate: _HeaderDelegate(
              minHeight: 50,
              maxHeight: 100,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'list 숫자',
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              )
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              customCard('1'),
              customCard('2'),
              customCard('3'),
              customCard('4'),
            ])
          ),
          SliverPersistentHeader(
            delegate: _HeaderDelegate(
                minHeight: 50,
                maxHeight: 100,
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '그리드 숫자',
                          style: TextStyle(fontSize: 30),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                )
            ),
            pinned: true,
          ),
          SliverGrid(
            delegate: SliverChildListDelegate([
              customCard('1'),
              customCard('2'),
              customCard('3'),
              customCard('4'),
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)
          )
        ],
      ),
    );
  }

  Widget customCard(String text) {
    return Card(
      child: Container(
        height: 120,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}

// SliverPersistentHeader를 이용해 슬리버 위젯별 헤더를 지정할 수 있음
// 그러려면 SliverPersistentHeaderDelegate 델리게이트가 필요
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _HeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 헤더를 만들 때 사용할 위젯 배치
    return SizedBox.expand(child: child,);
  }

  @override
  double get maxExtent => math.max(maxHeight, minHeight); // 해당 위젯의 최대 높이 설정

  @override
  double get minExtent => minHeight; // 해당 위젯의 최저 높이 설정 (이 높이 이하로는 머리말의 크기가 줄어들지 않음)

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) {
    // 위젯을 계속 그릴 것인지 결정
    // maxHeight, minHeight, child가 달라진다면 true를 반환해 다시 그릴 수 있도록 설정
    return maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
  }
}