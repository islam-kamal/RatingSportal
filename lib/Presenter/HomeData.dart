import 'package:flutter/material.dart';

class HomeData {
  final int id;
  final String name;
  final String picture;
  HomeData(
      {this.id,this.name,this.picture});
  factory HomeData.fromJson(Map<String,dynamic> json){
    return HomeData(
      id: json['id'],
      name: json['name'],
      picture:json['picture'],
    );
  }
}