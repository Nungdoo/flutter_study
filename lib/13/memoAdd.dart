import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  // 전면광고 전역변수
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    _createInterstitialAd(); // 전면광고 사용할 준비
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
                  _showInterstitialAd();
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

  // 전면광고 초기화 함수
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              print('$ad loaded');
              _interstitialAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error.');
              _interstitialAd = null;
            }
        )
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        // 전면 광고는 재사용이 어려워 사라지면 _createInterstitialAd() 함수로 다시 초기화
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
