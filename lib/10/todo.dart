class Todo {
  String? title;
  String? content;
  int? active; // 완료 여부 (SQLite는 bool 형이 없어 int형으로 처리)
  int? id;

  Todo({this.title, this.content, this.active, this.id});

  // 데이터를 Map 형태로 반환 (플러터의 sqflite 패키지가 데이터를 Map 형태로 다룸)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'active': active,
    };
  }
}