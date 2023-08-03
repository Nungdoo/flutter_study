import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoAddApp extends StatefulWidget {
  final DatabaseReference reference;

  MemoAddApp(this.reference);

  @override
  State<StatefulWidget> createState() => _MemoAddApp();
}

class _MemoAddApp extends State<MemoAddApp> {
  TextEditingController? titleController;
  TextEditingController? contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모 추가'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: '제목', fillColor: Colors.blueAccent),
              ),
              Expanded(
                child: TextField(
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 100,
                  decoration: InputDecoration(labelText: '내용'),
                )),
              MaterialButton(
                onPressed: () {
                  widget.reference
                    .push() // 데이터베이스에 데이터 저장
                    .set( // 어떤 데이터를 넣을지 정의
                      Memo(titleController!.value.text, contentController!.value.text, DateTime.now().toIso8601String()).toJson()
                    )
                    .then((_) { // 데이터 처리 후 어떤 동작할 지 정의
                      Navigator.of(context).pop();
                    });
                },
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                child: Text('저장하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
