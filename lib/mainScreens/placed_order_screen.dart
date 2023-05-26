// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:servemandu_users_app/assistantMethods/assistant_methods.dart';
import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/mainScreens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  
  String? addressID;
  double? totalAmount;
  String? sellerUID;
 
  PlacedOrderScreen({
    this.sellerUID,
    this.totalAmount,
    this.addressID,
    
  });

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {

  //getting order at real time
  DateTime orderATime = DateTime.now();
  String orderID = DateTime.now().millisecondsSinceEpoch.toString();

  // adding order details 
  addOrderDetails()
  {
    writeOrderDetailsForUser(
      {
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences!.getString("uid"),
        "serviceIDs": sharedPreferences!.getStringList("userCart"),
        "paymentDetails": "Cash on Delivery",
        "orderATime": orderATime,
        "orderTime": orderID, // gets assigned when rider (SP) confirms the order
        "isSuccess": true,
        "sellerUID": widget.sellerUID,
        "riderUID": "",
        "status": "normal",
        "orderId": orderID,
      });

      writeOrderDetailsForSeller(
        {
          "addressID": widget.addressID,
          "totalAmount": widget.totalAmount,
          "orderBy": sharedPreferences!.getString("uid"),
          "serviceIDs": sharedPreferences!.getStringList("userCart"),
          "paymentDetails": "Cash on Delivery",
          "orderATime": orderATime,
          "orderTime": orderID, // gets assigned when rider (SP) confirms the order
          "isSuccess": true,
          "sellerUID": widget.sellerUID,
          "riderUID": "",
          "status": "normal",
          "orderId": orderID,
        }).whenComplete(() //called when service provider has accepted the request of the user
        {
          clearCartNow(context);
          setState(() {
            orderID = "";
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
            Fluttertoast.showToast(msg: "Congratulations! Your order has been placed.");
          });
        });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
    .collection("users")
    .doc(sharedPreferences!.getString("uid"))
    .collection("orders")
    .doc(orderID)
    .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async
    {
      await FirebaseFirestore.instance
      .collection("orders")
      .doc(orderID)
      .set(data);
    }


  @override
  Widget build(BuildContext context) 
  {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.blueGrey
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset("images/delivery.jpg"),

            const SizedBox(height: 12,),

            ElevatedButton(
                onPressed: ()
                {
                  addOrderDetails();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: const EdgeInsets.all(14)
                ), 
                child: const Text("Place Order"),
                )
          ],
        ),
      ),
    );  
  }
}