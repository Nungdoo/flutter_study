import 'package:firebase_database/firebase_database.dart';

class Memo {
  String? key;
  String? title;
  String? content;
  String? createTime;

  Memo(this.title, this.content, this.createTime);

  /*Memo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value['title'],
        content = snapshot.value['content'],
        createTime = snapshot.value['createTime'];*/

  // fromSnapshot : 데이터베이스에서 데이터를 가져올 때 Memo 클래스의 변수에 넣어줌
  Memo.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;

    dynamic result = snapshot.value;
    title = result['title'];
    content = result['content'];
    createTime = result['createTime'];
  }

  // 데이터를 JSON 형태로 반환하는 함수
  toJson() {
    return {
      'title': title,
      'content': content,
      'createTime': createTime,
    };
  }

}