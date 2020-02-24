import 'package:flutter/material.dart';
import 'package:reviewers/Assisant/AppbarComponents.dart';

import 'Home.dart';

class ThanksMessage extends StatefulWidget {
  var branch;

  ThanksMessage(this.branch);

  @override
  State<StatefulWidget> createState() {
    print('branch id in thanks :$branch');
    return _ThanksMessageState(branch);
  }
}

class _ThanksMessageState extends State<ThanksMessage> {
  List rating;
  var branch;
  _ThanksMessageState(this.branch);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: AppBar(

        automaticallyImplyLeading: false,
      ),
      body: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        )),
        child: new Container(
            padding: EdgeInsets.only(top: 70.0),
            child: new Column(
              children: <Widget>[
                Image(
                  width: 400.0,
                  height: 200.0,
                  image: AssetImage('images/thanks.png'),
                ),
                new SizedBox(
                  height: 50.0,
                ),
                   new SizedBox(
                     width: MediaQuery.of(context).size.width/2,
                     child:  new RaisedButton(
                       color: Color.fromRGBO(95,158,160, 10),
                       child: new Text('أنهاء ',style: TextStyle(color: Colors.black),),
                       onPressed: () {
                        print('branch : $branch');
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => Home(branch: branch,)),
                         );
                       },
                     ),
                   ),


              ],
            )),
      ),

    );
  }
  void ratingResult(){
    rating=ModalRoute.of(context).settings.arguments;
    for(var i=0;i<rating.length;i++){
      print(rating[i]);
    }
  }

  @override
  void initState() {

  }
}
