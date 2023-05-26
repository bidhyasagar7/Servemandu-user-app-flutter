import 'package:flutter/cupertino.dart';
import 'package:servemandu_users_app/global/global.dart';

class CartServiceCounter extends ChangeNotifier
{
  // Shows number of items (services) present in the cart of the user.
  int cartListServiceCounter = sharedPreferences!.getStringList("userCart")!.length - 1; // -1 is to remove garbage value from the cart list

  int get count => cartListServiceCounter;

  Future<void> displayCartListServiceNumber() async
  {
    cartListServiceCounter = sharedPreferences!.getStringList("userCart")!.length -1;

    await Future.delayed(const Duration(milliseconds: 100), ()
    {
      notifyListeners(); //gives total number of services in the cart at real time
    });
  }

}