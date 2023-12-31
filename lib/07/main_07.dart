import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp()
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result = '';
  List? data;
  TextEditingController? _editingController;
  ScrollController? _scrollController;
  int page = 1;

  @override
  void initState() {
    super.initState();
    data = new List.empty(growable: true);
    _editingController = new TextEditingController();
    _scrollController = new ScrollController();

    // 스크롤할 때 이벤트 받도록 처리
    // offset : 목록에서 현재 위치를 double형 변수로 나타냄
    _scrollController!.addListener(() {
      if (_scrollController!.offset >= _scrollController!.position.maxScrollExtent && !_scrollController!.position.outOfRange) {
        print('bottom');
        page++;
        getJSONData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요'),
        )
      ),
      body: Container(
        child: Center(
          child: data!.length == 0
            ? Text('데이터가 없습니다.', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)
            : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Image.network(
                          data![index]['thumbnail'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                data![index]['title'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text('저자 : ${data![index]['authors'].toString()}'),
                            Text('가격 : ${data![index]['sale_price'].toString()}'),
                            Text('판매중 : ${data![index]['status'].toString()}'),
                          ],
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                );
              },
            itemCount: data!.length,
            controller: _scrollController,
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page = 1;
          data!.clear();
          getJSONData();
        },
        child: Icon(Icons.file_download),
      ),
    );
  }

  // 비동기로 데이터 주고 받음
  // Future : 비동기 처리에서 데이터를 바로 처리할 수 없을 때 사용
  Future<String> getJSONData() async {
    var uri = 'https://dapi.kakao.com/v3/search/book?target=title&page=$page&query=${_editingController!.value.text}';
    // url 주소에 데이터 요청
    var response = await http.get(Uri.parse(uri), headers: {
      "Authorization": "KakaoAK c53bd8a1e14013f3d60f909fb9fc95df"
    });

    //print("response.body : " + response.body);
    setState(() {
      // String > JSON
      var dataConvertedToJSON = json.decode(response.body);
      //print(dataConvertedToJSON);

      List result = dataConvertedToJSON['documents'];
      //print(result);

      data!.addAll(result);
      print(data);

    });
    return response.body;
  }
}