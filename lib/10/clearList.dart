import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'todo.dart';

class ClearListApp extends StatefulWidget {
  final Future<Database> database;
  ClearListApp(this.database);

  @override
  State<StatefulWidget> createState() => _ClearListApp();
}

class _ClearListApp extends State<ClearListApp> {
  Future<List<Todo>>? clearList;

  @override
  void initState() {
    super.initState();
    clearList = getClearList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo 추가'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Todo todo = (snapshot.data as List<Todo>)[index];
                        return ListTile(
                          title: Text(todo.title!, style: TextStyle(fontSize: 20),),
                          subtitle: Container(
                            child: Column(
                              children: <Widget>[
                                Text(todo.content!),
                                Container(height: 1, color: Colors.blue,)
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                    );
                  }
              }
              return Text('No data');
            },
            future: clearList,
          ),
        ),
      ),
    );
  }

  // 완료한 일만 불러오는 함수
  Future<List<Todo>> getClearList() async {
    final Database database = await widget.database;
    // rawQuery() 직접 SQL 질의문을 전달해 데이터베이스에 질의함
    List<Map<String, dynamic>> maps = await database.rawQuery('select title, content, id from todos where active=1');

    return List.generate(maps.length, (index) {
      return Todo(
        title: maps[index]['title'].toString(),
        content: maps[index]['content'].toString(),
        id: maps[index]['id'],
      );
    });
  }
}