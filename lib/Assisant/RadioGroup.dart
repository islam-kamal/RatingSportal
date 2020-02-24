import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
@override
RadioGroupWidget createState() => RadioGroupWidget();
}

class FruitsList {
  String name;
  int index;
  FruitsList({this.name, this.index});
}

class RadioGroupWidget extends State {


  // Default Radio Button Item
  String radioItem = 'ممتاز';

  // Group Value for Radio Button.
  int id = 1;

  List<FruitsList> fList = [
    FruitsList(
      index: 1,
      name: "ممتاز",
    ),
    FruitsList(
      index: 2,
      name: "جيد جدا",
    ),
    FruitsList(
      index: 3,
      name: "جيد",
    ),
    FruitsList(
      index: 4,
      name: "مقبول",
    ),
    FruitsList(
      index: 5,
      name: "ضعيف",
    ),
  ];

  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/world.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[

          Container(
            height: 290.0,
            width: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: Column(
              children: fList
                  .map((data) =>
                  RadioListTile(
                    title: Text(
                      "${data.name}",
                      style: TextStyle(color: Colors.white),
                    ),
                    groupValue: id,
                    value: data.index,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      setState(() {
                        radioItem = data.name;
                        print(radioItem);
                        id = data.index;
                        print(id); // we will use id to put in array  to calculate rating
                      });
                    },
                  ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}