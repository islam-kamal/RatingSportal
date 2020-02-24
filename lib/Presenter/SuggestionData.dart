import 'package:flutter/material.dart';

class SuggestionData {
  final String customer_name;
  final String text;
  final String mobile;
  final int type;
  final String branch_id;
  SuggestionData(
      {this.customer_name,this.text,this.mobile,this.type,this.branch_id}
      );
  factory SuggestionData.fromJson(Map<String,dynamic> json){
    print('1');
    // Map json=parsedJson['user'];
    print('json : '+json.toString());
    return SuggestionData(
        customer_name: json['customer_name'],
        text: json['text'],
        mobile: json['mobile'],
        type: json['type'],
        branch_id:json['branch_id']
    );

  }
}