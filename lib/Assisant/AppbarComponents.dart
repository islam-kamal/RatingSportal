import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reviewers/UI/CompainPage.dart';
import 'package:reviewers/UI/Doctors.dart';
import 'package:reviewers/UI/Home.dart';
import 'package:reviewers/UI/LoginPage.dart';

class AppComponents {
  static Widget DrawerMenu(BuildContext context,String branch_id){
    return new Drawer(
      child: new Container(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('images/reviewer.png'),
                    radius: MediaQuery.of(context).size.width / 8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Rating App',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
            ListTile(
              title: new Text(
                'الصفحة الرئيسية',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              leading: Icon(
                Icons.home,
                color: Colors.black,
                size: MediaQuery.of(context).size.width / 10,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return new Home(branch: branch_id,);
                    }));
              },
            ),
            /*
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: new Text(
                'التقييم',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              leading: Icon(
                Icons.rate_review,
                color: Colors.black,
                size: MediaQuery.of(context).size.width / 10,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return new Doctors();
                    }));
              },
            ),
            */
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: new Text(
                'المقترحات و الشكاوى',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              leading: Icon(
                Icons.message,
                color: Colors.black,
                size: MediaQuery.of(context).size.width / 10,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return new ComplainPage(
                        branch_id:branch_id,
                      );
                    }));
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: new Text(
                'الخروج',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: MediaQuery.of(context).size.width / 10,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                      return new LoginPage();
                    }));
              },
            ),
          ],
        ),
      ),
    );
  }
  static Widget HeaderTitle(String _pageName) {
   return new Text(_pageName,style: TextStyle(color: Colors.white,fontSize: 20),);
  }
  static Widget HeaderIcon(BuildContext context,var page_id){
     return  new IconButton(
         icon: Icon(Icons.home),
         iconSize: 30,
         onPressed: () {
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => Home(branch: page_id,)));
           print('${context.toString()} : $page_id');
         }

     );
  }

   void _ConnectionApiHandle(String url){
     var uri = "http://n5ba.com/Ratingsportal";
     BaseOptions options = BaseOptions(
        baseUrl: uri,
        responseType: ResponseType.plain,
        connectTimeout: 30000,
        receiveTimeout: 30000,
        validateStatus: (code) {
          if (code >= 200) {
            return true;
          }
        });
  }


}
