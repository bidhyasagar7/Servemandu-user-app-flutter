// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servemandu_users_app/assistantMethods/assistant_methods.dart';
import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/widgets/order_card.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';
import 'package:servemandu_users_app/widgets/simple_appbar.dart';

class MyOrdersScreen extends StatefulWidget {
  
  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "My Orders",),

        //retrieving users order
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPreferences!.getString("uid"))
            .collection("orders")
            .where("status", isEqualTo: "normal")
            .orderBy("orderTime", descending: true)
            .snapshots(),

          builder: (c, snapshots)
          {
            // check if firestore contains data for orders
            return snapshots.hasData
            ? ListView.builder // if yes, display them
            (
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (c, index)
              {
                //here selected item should match with the placed order to retrieve it from the firestore
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                    .collection("items")
                    .where("itemID", whereIn: seperateOrderServiceIDs((snapshots.data!.docs[index].data()! as Map<String, dynamic>) ["serviceIDs"]))
                    .where("orderBy", whereIn: (snapshots.data!.docs[index].data()! as Map<String, dynamic>)["uid"]) //checking the specific user
                    .orderBy("publishedDate", descending: true)
                    .get(), 

                  builder: (c, snap)
                  {
                    return snap.hasData 
                      ? OrderCard(
                          serviceCount: snap.data!.docs.length,
                          data: snap.data!.docs,
                          orderID: snapshots.data!.docs[index].id,
                          //seperateQuantitiesList: [], //seperateOrderServiceQuantities((snapshots.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"])
                        ) 
                      : Center(child: circularProgress(),);
                  },
                );
              },
            )

            : Center(child: circularProgress(),);//else, show circularProgress()
          }
        ),
      ),
    );
  }
}
