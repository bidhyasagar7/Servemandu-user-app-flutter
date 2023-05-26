// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servemandu_users_app/assistantMethods/address_changer.dart';
import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/mainScreens/save_address_screen.dart';
import 'package:servemandu_users_app/models/address.dart';
import 'package:servemandu_users_app/widgets/address_design.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';
import 'package:servemandu_users_app/widgets/simple_appbar.dart';

class AddressScreen extends StatefulWidget 
{
  final double? totalAmount;
  final String? sellerUID;

  const AddressScreen({this.totalAmount, this.sellerUID});


  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Servemandu"),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          //save address to user collection
          Navigator.push(context, MaterialPageRoute(builder: ((c) => SaveAddressScreen())));
        },
        label: Text("Add new address: "),
        backgroundColor: Colors.blueGrey,
        icon: Icon(Icons.add_location, color: Colors.blueAccent),
      ),

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.center,

        mainAxisSize: MainAxisSize.min,

        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Select Address: ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),


          // Displaying addresses from firestore
          Consumer<AddressChanger>(builder: (context, address, c){
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("userAddress").snapshots(),

                builder: (context, snapshot)
                {
                  //check if snapshot of userAddress contains data; if no data => circularProgress(), else if snapshot data length is 0 then either show blank container or show data in list view.
                  return !snapshot.hasData 
                  ? Center(child: circularProgress()) 
                  : snapshot.data!.docs.isEmpty 
                    ? Container() 
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index)
                        {
                          return AddressDesign(
                            currentIndex: address.count, // total number of addresses given by user
                            value: index, // index value
                            addressID: snapshot.data!.docs[index].id, 
                            totalAmount: widget.totalAmount,
                            sellerUID: widget.sellerUID,
                            model: Address.fromJson(
                              snapshot.data!.docs[index].data()! as Map<String, dynamic>
                            ),
                          );
                        },
                      );
                },
                ),
            );
          })
        ],
      ),
    );
  }
}