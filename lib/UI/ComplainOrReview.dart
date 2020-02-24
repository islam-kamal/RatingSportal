import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reviewers/UI/Doctors.dart';
import 'package:reviewers/UI/MessageType.dart';
import 'package:reviewers/UI/ReviewPage.dart';

import 'CompainPage.dart';

class ComplainOrReview extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ComplainOrReviewState();
  }
}

class _ComplainOrReviewState extends State<ComplainOrReview> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        )),
        child: new Column(
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
              child: FlatButton(
                  child: Image(
                    image: AssetImage('images/complain.png'),
                    alignment: Alignment.center,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageType()));
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
              child: FlatButton(
                  child: Image(
                    image: AssetImage('images/review.png'),
                    alignment: Alignment.center,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Doctors()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
