import 'package:flutter/cupertino.dart';

void main() {
  runApp(CupertinoMain());
}

class CupertinoMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CupertinoMain();
  }
}

class _CupertinoMain extends State<CupertinoMain> {
  CupertinoTabBar? tabBar;

  @override
  void initState() {
    super.initState();
    tabBar = CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.add)),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    // iOS style에서는 build 함수에서 CupertinoApp 반환
    // Cupertino 디자인의 위젯 묶음을 사용하기 위함
    return CupertinoApp(
      home: CupertinoTabScaffold(
        tabBar: tabBar!,
        tabBuilder: (context, value) {
          if (value == 0) {
            return Container(
              child: Center(
                child: Text('cupertino tab 1'),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Text('cupertino tab 2'),
              ),
            );
          }
        },
      ),
    );
  }
}

