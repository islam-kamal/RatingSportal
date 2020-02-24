import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reviewers/Assisant/AppbarComponents.dart';
import 'package:reviewers/Assisant/Todo.dart';
import 'package:reviewers/Presenter/UserLogin.dart';
import 'package:reviewers/UI/ComplainOrReview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CompainPage.dart';
import 'Doctors.dart';
import 'LoginPage.dart';
import 'LoginPage.dart';
import 'MessageType.dart';
import 'ReviewPage.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  var branch;

  Home({Key key, this.branch}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState(branch);
  }
}

class _HomeState extends State<Home> {
  var branchId;
  var department_id;
  List departmentData;
  _HomeState(var branch) {
    branchId = branch;
  }

  Future<List> getData() async {
    var response = await http.get(
        Uri.encodeFull(
            "http://n5ba.com/Ratingsportal/api/read_department_by_branch/$branchId"),
        headers: {"Accept": "application/json"});
    Map<String, dynamic> map = json.decode(response.body);
    List data = map["data"];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: AppComponents.HeaderTitle('الصفحة الرئيسية'),
        centerTitle: true,
        leading: AppComponents.HeaderIcon(context,branchId),

      ),
      body: new WillPopScope(
        onWillPop: () async => false,
        child: new Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) return new Container();
                departmentData = snapshot.data;
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: departmentData.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AspectRatio(
                              // use to make al l cells of grid view in same size
                              aspectRatio: 18.0 / 13.0,
                              child: Image(
                                //  image: AssetImage(departmentData[index][0]),
                                image: NetworkImage('http://n5ba.com/Ratingsportal/'+departmentData[index]['picture']),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(departmentData[index]['name'],
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      department_id = departmentData[index]['dprt_id'];
                      print('department : $department_id');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Doctors(
                                    department: department_id,
                                  )));
                    },
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                );
              }),
        ),
      ),
      endDrawer: AppComponents.DrawerMenu(context,branchId),
    );
  }
}
