import 'package:flutter/cupertino.dart';
import './animalItem.dart';

class CupertinoFirstPage extends StatelessWidget {
  final List<Animal> animalList;
  const CupertinoFirstPage({Key? key, required this.animalList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('동물 리스트'),
      ),
      child: ListView.builder(
        itemBuilder: (context, position) {
          return Container(
            padding: EdgeInsets.all(5),
            height: 100,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                        animalList[position].imagePath!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain
                    ),
                    Text(animalList[position].animalName!)
                  ],
                ),
                Container(
                  height: 2,
                  color: CupertinoColors.black,
                )
              ],
            ),
          );
      },
      itemCount: animalList.length,)
    );
  }
}

