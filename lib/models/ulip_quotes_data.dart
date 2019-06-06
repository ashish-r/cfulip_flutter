import 'package:flutter/material.dart';
class UlipQuotesData {
  final String insurerName;
  final String planName;
  final double maturityAmountAtPerformance;
  final double pastPerformance;

  UlipQuotesData({
    @required this.insurerName,
    @required this.planName,
    @required this.maturityAmountAtPerformance,
    @required this.pastPerformance,
  });
}