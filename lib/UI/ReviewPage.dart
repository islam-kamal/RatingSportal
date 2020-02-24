import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reviewers/Assisant/AppbarComponents.dart';
import 'package:reviewers/Assisant/RadioGroup.dart';
import 'package:reviewers/UI/ThanksMessage.dart';
import 'package:http/http.dart' as http;
import 'Home.dart';

class ReviewPage extends StatefulWidget {
  var doc_id;
  var branch_id;
  ReviewPage(this.doc_id,this.branch_id);

  @override
  State<StatefulWidget> createState() {
    return _ReviewPageState(doc_id,branch_id);
  }
}


class _ReviewPageState extends State<ReviewPage> {
  var doctor_id;
  var branch_id;
  List questionDataList;
  List answerDataList;
  var question;
  var question_id;
  var response;
  bool choicedAnswer = false;


  _ReviewPageState(this.doctor_id,this.branch_id);

  Future<List> getData() async {
    response = await http.get(
        Uri.encodeFull(
            "http://n5ba.com/Ratingsportal/api/read_questions_by_doctor/$doctor_id"),
        headers: {"Accept": "application/json"});
    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List data = map["data"];
    //   print(data);
    return data;
  }

  Future<List> getAnswers() async {
    response = await http.get(
        Uri.encodeFull(
            "http://n5ba.com/Ratingsportal/api/read_answers_by_question/${question_id}"),
        headers: {"Accept": "application/json"});
    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List data = map["data"];
    //print(data);
    return data;
  }
  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  var questionTextField = new TextEditingController();
  var index;
  var buttonText = 'التالى';
  var nextButton;

  @override
  void initState() {
    index = 1;
    print('branch id :$branch_id');
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to return to Doctors Page'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
  //..........................................................
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:   new Scaffold(
        appBar: AppBar(
//        leading: AppComponents.HeaderIcon(context),
          title: AppComponents.HeaderTitle('صفحة التقييم'),
          centerTitle: true,
        ),
        body: new Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: getData(),
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (!snapshot.hasData) return new Container();
                    questionDataList = snapshot.data;
                    if(index<=questionDataList.length){
                      question_id = questionDataList[index]['id']; // get question id to get its answers
                      print('question_id : $question_id');
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: Container(
                          child: new TextField(
                            controller: questionTextField,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: questionDataList[0]['question'],
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              // to create border for TextField
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(49, 103, 115, 5),
                                  width: 3.0,
                                ),
                              ),
                            ),
                            enabled: false,
                          ),
                          color: Colors.cyan,
                        ),
                      );
                    }
                    else{
                      print('sorry');
                    }

                  }),

              Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 30),
                child: Column(
                  children: <Widget>[
                    new SafeArea(
                      child: SingleChildScrollView(
                        child: new Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width/1.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                            child: FutureBuilder(
                                future: getAnswers(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List> snapshot) {
                                  if (!snapshot.hasData) return new Container();
                                  answerDataList = snapshot.data;
                                  return ListView.builder(
                                    itemCount: answerDataList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Ink(
                                        color:  _selectedIndex != null && _selectedIndex == index
                                            ? Colors.blue
                                            : Colors.grey,
                                        child: ListTile(
                                            title: Text(
                                              '${answerDataList[index]['answer']}',
                                            ),
                                            onTap: () {
                                              choicedAnswer=true;
                                              _onSelected(index);
                                            }),
                                      );
                                    },
                                  );
                                }),

                        ),
                      ),
                    ),
                  ],
                ),


              ),


              SizedBox(

                height: 30.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: new RaisedButton(
                      key: nextButton,
                      child: new Text(
                        buttonText, //................... next ............
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      //use to make circle border for button
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(2.0),
                        side: BorderSide(
                          color: Colors.cyan,
                        ),
                      ),
                      color: Colors.cyan,

                      onPressed: () {
                        setState(() {
                          questionTextField.text = questionDataList[index]['question'];
                          /* if (choicedAnswer) {
                          index++;
                        } */if (true) {
                            index++;
                          } else {
                            //  should appear wrong mesage
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Choice one of these Options"),
                            ));
                          }
                          if (index == questionDataList.length) {
                            buttonText = 'انهاء';

                            if (buttonText == 'انهاء') {
                              setState(() {
                                print('branch id in review : $branch_id');
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context)=>ThanksMessage(branch_id),
                                ));
                              });
                            }
                          }
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

}
