import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'memoPage.dart';

void main() {
  /*
  Firebase.initializeApp()는 Firebase를 초기화하기 위해 네이티브 코드를 호출해야 함
  네이티브 코드를 호출하려면 플랫폼 채널을 사용해야 함
  플랫폼 채널을 비동기적으로 작동하므로,
  WidgetsFlutterBinding.ensureInitialized()를 통해 플랫폼 채널의 위젯 바인딩을 보장해야 함
  */
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error'),);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _initFirebaseMessaging(context);
            _getToken();
            return MemoPage();
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  _initFirebaseMessaging(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print(event.notification!.title);
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')
                )
              ],
            );
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {

    });
  }

  _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    print('messaging.getToken() , ${await messaging.getToken()}');
  }
}