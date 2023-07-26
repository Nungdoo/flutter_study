import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LargeFileMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LargeFileMain();
}

class _LargeFileMain extends State<LargeFileMain> {
  // 내려받을 이미지 주소
  final imgUrl = 'https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg?auto=compress';
  // 지금 내려받는 중인지 확인하는 변수
  bool downloading = false;
  // 현재 얼마나 내려받았는지 표시하는 변수
  var progressString = "";
  // 내려받은 파일
  String file = "";

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Large File Example'),
      ),
      body: Center(
          child: downloading ? Container( // 파일을 내려받는 중이면
            height: 120.0,
            width: 200.0,
            child: Card(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20.0,), // 고정된 높이와 넓이 안에서 네모난 형태의 위젯을 만들 수 있음
                  Text('Downloading File: $progressString', style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
          )
              : FutureBuilder( // FutureBuilder : 아직은 데이터가 없지만 앞으로 데이터를 받아서 처리한 후에 만들겠다는 의미
            builder: (context, snapshot) { // builder에서 snapshot이라는 변수를 반환함 : FutureBuilder.future에서 받아온 데이터를 저장한 dynamic 형태의 변수
              switch(snapshot.connectionState) {
                case ConnectionState.none: // FutureBuilder.future가 null일 때
                  print('none');
                  return Text('데이터 없음');
                case ConnectionState.waiting: // 연결되기 전 (Futurebuilder.future에서 데이터를 반환받지 않았을 때)
                  print('waiting');
                  return CircularProgressIndicator();
                case ConnectionState.active: // 하나 이상의 데이터를 반환받을 때
                  print('active');
                  return CircularProgressIndicator();
                case ConnectionState.done: // 모든 데이터를 받아서 연결이 끝날 때
                  print('done');
                  if (snapshot.hasData) {
                    return snapshot.data as Widget;
                  }
              }
              print('end process');
              return Text('데이터 없음');
            },
            future: downloadWidget(file),
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          downloadFile();
        },
        child: Icon(Icons.file_download),
      ),
    )   ;
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      // getApplicationDocumentsDirectory() : 플러터 앱의 내부 디렉터리를 가져옴
      var dir = await getApplicationDocumentsDirectory();

      // 파일 경로에 내려받기
      // 데이터를 받을 때마다 onReceiveProgress() 함수 실행해 진행 상황 표시
      // rec : 지금까지 내려받은 데이터, total : 파일의 전체 크기
      await dio.download(imgUrl, '${dir.path}/myimage.jpg', onReceiveProgress: (rec, total) {
        print('Rec: $rec, Total: $total');
        file = '${dir.path}/myimage.jpg';
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = 'Completed';
    });
    print('Download completed');
  }

  // 이미지 파일이 있는지 확인해서 반환
  Future<Widget> downloadWidget(String filePath) async {
    File file = File(filePath);
    bool exist = await file.exists();
    new FileImage(file).evict(); // 캐시 초기화하기

    if (exist) {
      return Center(
        child: Column(
          children: <Widget>[Image.file(File(filePath))],
        ),
      );
    } else {
      return Text('No Data');
    }
  }
}