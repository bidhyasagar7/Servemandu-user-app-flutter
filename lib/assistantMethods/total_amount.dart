// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier
{
  double _totalAmount = 0;

  double get tAmount => _totalAmount;

  displayTotalAmount(double number) async
  {
    _totalAmount = number;

    await Future.delayed(const Duration(milliseconds: 100), ()
    {
      notifyListeners();
    });
  }
}