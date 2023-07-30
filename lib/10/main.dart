import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';
import 'addTodo.dart';
import 'clearList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        // 각 클래스를 호출하면서 database 객체를 전달함
        '/': (context) => DatabaseApp(database),
        '/add': (context) => AddTodoApp(database),
        '/clear': (context) => ClearListApp(database),
      },
    );
  }

  // 다른 클래스에서도 접근할 수 있게 가장 먼저 생성되는 MyApp 클래스에 데이터베이스 선언
  Future<Database> initDatabase() async {
    return openDatabase(
      // getDatabasesPath() 경로에 todo_database.db 파일로 저장된 DB를 반환함
      join(await getDatabasesPath(), 'todo_database.db'),
      // 해당 파일에 테이블이 없으면 새로운 테이블 생성
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, content TEXT, active INTEGER)",
        );
      },
      version: 1
    );
  }
}

class DatabaseApp extends StatefulWidget {
  final Future<Database> db;
  DatabaseApp(this.db);

  @override
  State<StatefulWidget> createState() => _DatabaseApp();
}

class _DatabaseApp extends State<DatabaseApp> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database Example'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed('/clear');
              setState(() {
                todoList = getTodos();
              });
            },
            child: Text(
              '완료한 일',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: FutureBuilder( // 서버에서 데이터를 받거나 파일에서 데이터를 가져올 때 사용
            builder: (context, snapshot) { // snapshot을 통해 비동기 처리 결과를 얻을 수 있음
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done: // 상태가 done이 되면 가져온 데이터를 바탕으로 화면에 표시
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Todo todo = (snapshot.data as List<Todo>)[index];
                        return ListTile( // 클릭할 수 있는 onTap() 함수가 포함된 목록을 만듦
                          title: Text(todo.title!, style: TextStyle(fontSize: 20),),
                          subtitle: Container(
                            child: Column(
                              children: <Widget>[
                                Text(todo.content!),
                                Text('체크 : ${todo.active == 1 ? 'true' : 'false'}'),
                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            Todo result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('${todo.id} : ${todo.title}'),
                                  content: Text('Todo를 체크하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          todo.active == 1 ? todo.active = 0 : todo.active = 1;
                                        });
                                        Navigator.of(context).pop(todo);
                                      },
                                      child: Text('예')
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(todo);
                                        },
                                        child: Text('아니오')
                                    ),
                                  ],
                                );
                              }
                            );
                            _updateTodo(result);
                          },
                          onLongPress: () async {
                            Todo result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('${todo.id} : ${todo.title}'),
                                  content: Text('${todo.content}를 삭제하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(todo);
                                      },
                                      child: Text('예')
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('아니오')
                                    ),
                                  ],
                                );
                              }
                            );
                            _deleteTodo(result);
                          },
                        );
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                    );
                  } else {
                    return Text('No data');
                  }
              }
              return CircularProgressIndicator();
            },
            // future에 FutureBuilder가 처리할 Future 객체를 바인딩함
            future: todoList,
          ),
        ),
      ),
      floatingActionButton: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              final todo = await Navigator.of(context).pushNamed('/add');
              if (todo != null) {
                _insertTodo(todo as Todo);
              }
            },
            // heroTag를 null로 설정하지 않으면,
            // 화면을 넘길 때 플러터에서 자연스러운 애니메이션을 자동으로 추가하는데,
            // 페이지가 넘어가는 위젯에 받아줄 태그가 없어서 에러 발생
            heroTag: null,
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              _allUpdate();
            },
            heroTag: null,
            child: Icon(Icons.update),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }

  void _insertTodo(Todo todo) async {
    // widget을 이용하면 현재 State 상위에 있는 StatefulWidget에 있는 db 변수를 사용할 수 있음
    final Database database = await widget.db;
    await database.insert('todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    setState(() {
      todoList = getTodos();
    });
  }

  Future<List<Todo>> getTodos() async {
    final Database database = await widget.db;
    // todos 테이블을 가져옴
    final List<Map<String, dynamic>> maps = await database.query('todos');

    return List.generate(maps.length, (index) {
      int active = maps[index]['active'] == 1 ? 1 : 0;
      return Todo(
        title: maps[index]['title'].toString(),
        content: maps[index]['content'].toString(),
        active: active,
        id: maps[index]['id'],
      );
    });
  }

  void _updateTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',      // 어떤 데이터를 수정할 것인지
      whereArgs: [todo.id], // ? 가 whereArgs와 대응됨
    );
    setState(() {
      todoList = getTodos();
    });
  }

  void _deleteTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [todo.id]
    );
    setState(() {
      todoList = getTodos();
    });
  }

  void _allUpdate() async {
    final Database database = await widget.db;
    await database.rawUpdate('update todos set active=1 where active=0');
    setState(() {
      todoList = getTodos();
    });
  }
}