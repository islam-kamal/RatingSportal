import 'package:flutter/material.dart';

class UserLogin {
  final String email;
  final String password;
  final String user_role;
  final int branch_id;
  UserLogin(
      {this.email,this.password,this.user_role,this.branch_id}
      );
  factory UserLogin.fromJson(Map<String,dynamic> json){
    print('1');
    // Map json=parsedJson['user'];
    print('json : '+json.toString());
    return UserLogin(
        email: json['email'],
        password: json['password'],
        user_role: json['user_role'],
        branch_id: json['id']
    );

  }
}