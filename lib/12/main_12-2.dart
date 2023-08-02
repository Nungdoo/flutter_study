import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // MethodChannel을 이용하기 위함

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SendDataExample()
    );
  }
}

class SendDataExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SendDataExample();
}

class _SendDataExample extends State<SendDataExample> {
  // 안드로이드와의 통신 채널
  // 어떤 통신을 할 것인지 키값을 넘김
  static const platform = const MethodChannel('com.flutter.dev/encrypto');

  TextEditingController controller = new TextEditingController();
  String _changeText = 'Nothing';
  String _reChangeText = 'Nothing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send data Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20,),
              Text(
                _changeText,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  _decodeText(_changeText);
                },
                child: Text('디코딩하기')
              ),
              SizedBox(height: 20,),
              Text(
                _reChangeText,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sendData(controller.value.text);
        },
        child: Text('변환'),
      ),
    );
  }

  Future<void> _sendData(String text) async {
    final String result = await platform.invokeMethod('getEncrypto', text);
    setState(() {
      _changeText = result;
    });
  }

  void _decodeText(String changeText) async {
    final String result = await platform.invokeMethod('getDecode', changeText);
    setState(() {
      _reChangeText = result;
    });
  }
}