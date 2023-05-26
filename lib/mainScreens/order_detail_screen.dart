// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/models/address.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';
import 'package:servemandu_users_app/widgets/shipment_address_design.dart';
import 'package:servemandu_users_app/widgets/status_banner.dart';

class OrderDetailScreen extends StatefulWidget {
  
  final String? orderID;

  OrderDetailScreen(
    {
      this.orderID
    }
  );
  
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  
  String orderStatus = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        //showing each order details
        child: FutureBuilder<DocumentSnapshot>
        (
          future: FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPreferences!.getString("uid"))
            .collection("orders")
            .doc(widget.orderID)
            .get(),

          builder: (c, snapshots)
          {
            Map? dataMap;
            if(snapshots.hasData)
            {
              dataMap = snapshots.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshots.hasData 
            ? Container(
                child: Column(
                  children: [

                    //displaying order status
                    StatusBanner(
                      status: dataMap!["isSuccess"],
                      orderStatus: orderStatus,
                    ),

                    const SizedBox(height: 20.0,),

                    //displaying total amount
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Rs. " + dataMap["totalAmount"].toString(),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    //displaying order ID
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Order ID = " + widget.orderID!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  
                    //displaying order data & time
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Order at: " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),

                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  
                    const SizedBox(height: 20.0,),


                    const Divider(thickness: 4,),

                    orderStatus == "ended" 
                    ? Image.asset("images/delivered.jpg")
                    : Image.asset("images/state.jpg"),

                    const Divider(thickness: 4,),

                    const SizedBox(height: 20.0,),


                    //displaying users address for service delivery
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress") // choosing the unique address among different addresses provided by user
                        .doc(dataMap["addressID"])
                        .get(),

                      //displaying final address selected by user from shipment_address_design.dart
                      builder: (c, snapshot)
                      {
                        return snapshot.hasData 
                        ? ShipmentAddressDesign
                          (
                            model: Address.fromJson(
                              snapshot.data!.data()! as Map<String, dynamic>
                            ),
                          )
                        : Center(child: circularProgress(),);
                      },
                    )
                  ],
                ),
            ) 
            : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}