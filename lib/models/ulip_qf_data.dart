import 'package:flutter/material.dart';
import 'dart:convert';
class UlipQfData {
  final String investmentFrequency;
  final int investmentAmount;
  final int PPT;
  final int PT;
  final int planType;
  final int age;
  final int income;
  final int mobile;
  final String email;
  final int goalId;
  final int currentCost;
  final int retirementLifestyle;
  final String countryCode;
  final int sumAssured;
  final String sales_channel;

  UlipQfData({
    @required this.investmentFrequency, 
    @required this.investmentAmount, 
    @required this.PPT,
    @required this.PT,
    @required this.planType,
    @required this.age,
    @required this.income,
    @required this.mobile,
    this.email,
    this.goalId = 0,
    this.currentCost,
    this.retirementLifestyle,
    this.countryCode = "+91",
    this.sumAssured,
    this.sales_channel = "coverfox",
  });

  String toJSON() {
    return json.encode({
      'investmentFrequency': investmentFrequency,
      'investmentAmount': investmentAmount,
      'PPT': PPT,
      'PT': PT,
      'planType': planType,
      'age': age,
      'income': income,
      'mobile': mobile,
      'email': email,
      'goalId': goalId,
      'currentCost': currentCost,
      'retirementLifestyle': retirementLifestyle,
      'countryCode': countryCode,
      'sumAssured': sumAssured,
      'sales_channel': sales_channel,
    });
  }

}