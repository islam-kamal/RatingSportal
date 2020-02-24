import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reviewers/Assisant/ApiFunctions.dart';
import 'package:reviewers/Assisant/ApiFunctions.dart';
import 'package:reviewers/Assisant/AppbarComponents.dart';
import 'package:reviewers/Assisant/Todo.dart';
import 'package:reviewers/Presenter/UserLogin.dart';

import 'Home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  var branch_id;

  static var uri = "http://n5ba.com/Ratingsportal";
  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
      });

  static Dio dio = Dio(options);

  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  Future<dynamic> _loginUser(
      String email, String password, int user_role) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json'),
      );

      print(email + ' : ' + password);
      Response response = await dio.post('/api/login',
          data: {"email": email, "password": password, 'user_role': 3},
          options: options);

      print('response : ' + response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect Phone/Password");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(49, 103, 115, 5),
        centerTitle: true,
        title: Text(
          'Rating',
          style: TextStyle(
            color: Colors.white,
            height: 2.0,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: new Container(
        alignment: Alignment.center,
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new SafeArea(
          child: new SingleChildScrollView(
            child: new Container(
              width: MediaQuery.of(context).size.width / 1.2,
              alignment: Alignment.center,
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('images/reviewer.png'),
                      maxRadius: 80,
                      minRadius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Container(
                      child: new Column(
                        textDirection: TextDirection.rtl,
                        // mainAxisSize: MainAxisSize.min,
                        //  mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: new Column(
                              children: <Widget>[
                                new TextField(
                                    controller: _emailController,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'اسم المستخدم',
                                      // to add icon from right side
                                      suffixIcon: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 0.0),
                                          child: new Icon(
                                            Icons.person,
                                            color: Colors.cyan,
                                          )),
                                      hintStyle: TextStyle(
                                        color: Colors
                                            .black, // make hint text with white color
                                      ),
                                    )),
                                new TextField(
                                  controller: _passwordController,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 0.0),
                                      child: new Icon(Icons.lock,
                                          color: Colors.cyan),
                                    ),
                                    hintText: 'كلمة المرور',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                ),
                                new Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(15.0),
                                  child: new InkWell(
                                    child: new Text(
                                      'نسيت كلمة المرور ؟',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            child: new Center(
                              child: new Column(
                                children: <Widget>[
                                  new SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: new RaisedButton(
                                      onPressed: () async {
                                        setState(() => _isLoading = true);
                                        // print(_phoneController.text + ' , '+_passwordController.text);
                                        var res = await _loginUser(
                                            _emailController.text.trim(),
                                            _passwordController.text.trim(),
                                            3);
                                        setState(() => _isLoading = false);
                                        // print('res : ' + res.toString());
                                        var status = res['status'];
                                        branch_id = res['user_data']['id'];
                                        print('branch id :  ${branch_id}');
                                        try {
                                          if (status == true) {
                                            //navigate to home screen and pass branch_id from login to home
                                            Navigator.of(context).push(
                                                MaterialPageRoute<Null>(builder:
                                                    (BuildContext context) {
                                              return new Home(
                                                branch: branch_id,
                                              );
                                            }));
                                            print('navigation done sucess');
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Wrong email or")));
                                          }
                                        } on Exception catch (_) {
                                          throw Exception("Error on server");
                                        }
                                      },

                                      child: new Text(
                                        "تسجيل الدخول",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      //use to make circle border for button
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(22.0),
                                        side: BorderSide(
                                          color: Colors.cyan,
                                        ),
                                      ),
                                      color: Colors.cyan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
/*
 void _NavigateToHome(BuildContext context) async{
     UserLogin user=new UserLogin();
    final result=await Navigator.push(context, MaterialPageRoute(
      builder: (context)=>Home(
        user1:user,
      )
    ));
    print(result);
 }

 */
}
