import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reviewers/UI/AudioRecorder.dart';
import 'package:reviewers/UI/ReviewPage.dart';

import 'CompainPage.dart';
import 'Home.dart';

class MessageType extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageTypeState();
  }
}

class _MessageTypeState extends State<MessageType> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading:   new IconButton(
            icon: Icon(Icons.home),
            iconSize: 40,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Home();
                  }));
            }
        ),
      ),
      body: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/world.png'),
          fit: BoxFit.cover,
        )),
        child:
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.white24,
                border: Border.all(width: 2.0, color: Colors.white),
              ),
              child: FloatingActionButton(
                  heroTag: "btn1",
                  child: new Icon(
                    Icons.mic,
                    size: 50,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AudioRecorder()));
                  }),
            ),
            SizedBox(
              height: 30,
            ),
            new Container(
              width: 220,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.white24,
                border: Border.all(width: 2.0, color: Colors.white),
              ),
              child: FloatingActionButton(
                  heroTag: "btn2",
                  child: new Icon(
                    Icons.message,
                    size: 50,
                  ),
                  onPressed: () {
                    /*
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComplainPage()));*/
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
