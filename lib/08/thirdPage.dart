import 'package:flutter/material.dart';

class ThirdDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 라우터로 전달받은 데이터 가져오기
    final String args = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Container(
        child: Center(
          child: Text(
            args,
            style: TextStyle(fontSize: 30),
          )
        ),
      ),
    );
  }
}