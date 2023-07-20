import 'package:flutter/cupertino.dart';
import './animalItem.dart';

class CupertinoSecondPage extends StatefulWidget {
  final List<Animal> animalList;
  const CupertinoSecondPage({Key? key, required this.animalList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CupertinoSecondPage();
}

class _CupertinoSecondPage extends State<CupertinoSecondPage> {
  TextEditingController? _textController;
  int _kindChoice = 0;
  bool _flyExist = false;
  String? _imagePath;

  // SizedBox : 영역을 만들어 주는 위젯
  Map<int, Widget> segmentWidgets = {
    0: SizedBox(
      child: Text('양서류', textAlign: TextAlign.center,),
      width: 80,
    ),
    1: SizedBox(
      child: Text('포유류', textAlign: TextAlign.center,),
      width: 80,
    ),
    2: SizedBox(
      child: Text('파충류', textAlign: TextAlign.center,),
      width: 80,
    ),
  };

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('동물 추가'),
      ),
      child: Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CupertinoTextField(
                    controller: _textController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                  )
                ),
                CupertinoSegmentedControl(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                    groupValue: _kindChoice,
                    children: segmentWidgets,
                    onValueChanged: _segmentChange
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('날 수 있나요?'),
                    CupertinoSwitch(
                        value: _flyExist,
                        onChanged: (value) {
                          setState(() {
                            _flyExist = value;
                          });
                        }
                    )
                  ],
                ),
                Container(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        GestureDetector(
                          child: Image.asset('image/bee.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/bee.png';
                          },
                        ),
                        GestureDetector(
                          child: Image.asset('image/cat.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/cat.png';
                          },
                        ),
                        GestureDetector(
                          child: Image.asset('image/cow.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/cow.png';
                          },
                        ),
                        GestureDetector(
                          child: Image.asset('image/dog.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/dog.png';
                          },
                        ),
                        GestureDetector(
                          child: Image.asset('image/fox.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/fox.png';
                          },
                        ),
                        GestureDetector(
                          child: Image.asset('image/monkey.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/monkey.png';
                          },
                        ),
                        GestureDetector(
                          child: Image.asset('image/pig.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/pig.png';
                          },
                        ),
                        GestureDetector(
                          child: Image.asset('image/wolf.png', width: 80,),
                          onTap: () {
                            _imagePath = 'image/wolf.png';
                          },
                        ),
                      ],
                    )
                ),
                CupertinoButton(
                  onPressed: () {
                    var animal = Animal(
                        animalName: _textController?.value.text,
                        kind: getKind(_kindChoice),
                        imagePath: _imagePath,
                        flyExist: _flyExist
                    );
                    CupertinoAlertDialog dialog = CupertinoAlertDialog(
                      title: Text('동물 추가하기'),
                      content: Text(
                        '이 동물은 ${animal.animalName} 입니다. \n또 이 동물의 종류는 ${animal.kind} 입니다. \n이 동물을 추가하시겠습니까?',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      actions: [
                        CupertinoButton(
                            onPressed: (){
                              widget.animalList.add(animal);
                              Navigator.of(context).pop();
                            },
                            child: Text('예')
                        ),
                        CupertinoButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text('아니요')
                        ),
                      ],
                    );
                    showCupertinoDialog(context: context, builder: (BuildContext context) => dialog);
                  },
                  child: Text('동물 추가하기')
                )
              ],
            )
        ),
      )
    );
  }

  _segmentChange(int value) {
    setState(() {
      _kindChoice = value;
    });
  }

  getKind(int kindChoice) {
    switch(kindChoice) {
      case 0:
        return "양서류";
      case 1:
        return "포유류";
      case 2:
        return "파충류";
    }
  }
}

