import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'largeFileMain.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FileApp()
    );
  }
}

class FileApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FileApp();
}

class _FileApp extends State<FileApp> {
  int _count = 0;
  List<String> itemList = new List.empty(growable: true);
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    readCountFile();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로고바꾸기'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LargeFileMain()));
            },
            child: Text(
              '로고바꾸기',
              style: TextStyle(color: Colors.white),
            )
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              Expanded(
                // ListView.builder는 내용에 따라 알아서 크기를 조절해서 배치하지 못해, Expanded 위젯 사용
                // 남은 공간 전부 사용함
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: Center(
                        child: Text(
                          itemList[index],
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    );
                  },
                  itemCount: itemList.length,
                ),
              ),
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeFruit(controller.value.text);
          setState(() {
            itemList.add(controller.value.text);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void writeCountFile(int count) async {
    var dir = await getApplicationDocumentsDirectory();
    File(dir.path + '/count.txt').writeAsStringSync(count.toString());
  }

  void readCountFile() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      var file = await File(dir.path + '/count.txt').readAsString();
      print(file);

      setState(() {
        _count = int.parse(file);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void initData() async {
    // initState() 함수에선 async를 사용할 수 없어, 별도의 initData() 함수를 만듦
    var result = await readListFile();
    setState(() {
      itemList.addAll(result);
    });
  }

  // fruit.txt 파일에서 데이터를 읽어와
  // 내부 저장소인 공유 환경설정에 저장한 다음 리스트를 만듦
  Future<List<String>> readListFile() async {
    List<String> itemList = new List.empty(growable: true);
    var key = 'first';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? firstCheck = pref.getBool(key); // 파일을 처음 열었는지 확인하는 용도
    var dir = await getApplicationDocumentsDirectory();
    bool fileExist = await File(dir.path + '/fruit.txt').exists(); // 파일이 있는지 확인하는 용도

    // readListFile() 함수를 처음 실행하면
    // 애셋에 등록한 파일을 읽어서 내부 저장소에 다시 저장함
    if (firstCheck == null || firstCheck == false || fileExist == false) {
      pref.setBool(key, true); // 파일을 연 것으로 기록
      var file = await DefaultAssetBundle.of(context).loadString('repo/fruit.txt'); // 애셋에 등록한 repo/fruit.txt 파일을 읽음

      File(dir.path + '/fruit.txt').writeAsStringSync(file); // repo/fruit.txt 와 똑같은 파일을 만듦
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    } else { // 내부 저장소에 있는 파일(/fruit.txt) 데이터를 불러와 리스트를 만듦
      var file = await File(dir.path + '/fruit.txt').readAsString();
      var array = file.split('\n');
      for (var item in array) {
        print(item);
        itemList.add(item);
      }
      return itemList;
    }
  }

  void writeFruit(String fruit) async {
    var dir = await getApplicationDocumentsDirectory();
    var file = await File(dir.path + '/fruit.txt').readAsString();
    file = file + '\n' + fruit;
    File(dir.path + '/fruit.txt').writeAsStringSync(file);
  }
}
