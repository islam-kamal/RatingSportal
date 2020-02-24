import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:reviewers/Assisant/AppbarComponents.dart';
import 'package:reviewers/UI/ReviewPage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'Home.dart';
import 'ReviewPage.dart';
import 'package:http/http.dart' as http;

class Doctors extends StatefulWidget {
  var department;
  Doctors({Key key, this.department}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _DoctorsState(department);
  }
}
class _DoctorsState extends State<Doctors> {
  var branch_id;
  var departmentId;
  var doctor_id;
  List DoctorsData;

  @override
  void initState() {
  }
  _DoctorsState(var department_id) {
    departmentId = department_id;
  }
  Future<List> getData() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://n5ba.com/Ratingsportal/api/read_doctors_by_department/$departmentId"),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> map = json.decode(response.body);
    List data = map["data"];
    return data;
  }

  Widget _DoctorDtails(BuildContext context, int index) {
    return new Card(
      child: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: new Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 5),
          height: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            border: Border.all(
              color: Colors.white,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
          child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) return new Container();
                DoctorsData = snapshot.data;
                return new ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    new Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          //  padding: EdgeInsets.only(left: 13, right: 5, top:5),
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DoctorsData[index]['firstname'] + ' ' + DoctorsData[index]['lastname']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Row(
                                    //use to show rating for doctors , pharmacies, hospitals
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SmoothStarRating(
                                        starCount: 5,
                                        color: Colors.yellowAccent.shade700,
                                        borderColor: Colors.white,
                                        allowHalfRating: true,
                                        rating:
                                            2, // detect rate for each doctor and take its value from rating which user do
                                        size: 12,
                                        spacing: 2,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "15 تقيم", // number of reviews take its value from counter every review user make to doctor
                                        style: TextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 5, top: 0),
                                  child: Text(
                                    DoctorsData[index]['specialist'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 5, top: 0),
                                  child: Text(
                                    DoctorsData[index]['address'],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                new Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  padding: EdgeInsets.only(top: 5),
                                  child: new RaisedButton(
                                    onPressed: () {
                                      doctor_id = DoctorsData[index]['user_id'];

                                      Navigator.of(context).push(
                                          MaterialPageRoute<Null>(
                                              builder: (BuildContext context) {
                                        return new ReviewPage(doctor_id,branch_id);
                                      }));
                                    },
                                    child: new Text(
                                      "تقييم الطبيب",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(12.0),
                                      side: BorderSide(
                                          color: Colors.white, width: 2),
                                    ),
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CircleAvatar(
                          // will use images  stored in doctor list
                          //   backgroundImage: AssetImage('images/doctor1.png'),
                          backgroundImage: NetworkImage(
                              "http://n5ba.com/Ratingsportal/${DoctorsData[index]['picture']}"),
                          radius: MediaQuery.of(context).size.width / 9,
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: AppComponents.HeaderTitle('الاطباء'),
        centerTitle: true,
        leading:  new IconButton(
            icon: Icon(Icons.home),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(branch: branch_id,)));
              print('${context.toString()} : $branch_id');
            }
        ),
      ),
      body: new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.png'), fit: BoxFit.cover)),
        padding: EdgeInsets.all(10),
        /*
        child: ListView.builder(
          controller: null,
          scrollDirection: Axis.vertical,
         // itemCount: DoctorsData.length,
          itemCount:2,
          itemBuilder: _DoctorDtails,
        ),

         */
        child: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) return new Container();
              DoctorsData = snapshot.data;
              branch_id=DoctorsData[0]['branch_id'];
              return ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: DoctorsData.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(child: _DoctorDtails(context, index)),
              );
            }),
      ),
    );
  }
}
