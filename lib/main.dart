import 'package:flutter/material.dart';
import 'package:reviewers/UI/AudioRecorder.dart';
import 'package:reviewers/UI/Doctors.dart';
import 'package:reviewers/UI/LoginPage.dart';
import 'Assisant/SearchIcon.dart';
import 'UI/CompainPage.dart';
import 'UI/Home.dart';
import 'UI/ReviewPage.dart';
import 'UI/UploadMultipleImageDemo.dart';

void main(){
  runApp(
    new MaterialApp(
      title: 'Rating',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'JF Flat'),
    ),
  );
}