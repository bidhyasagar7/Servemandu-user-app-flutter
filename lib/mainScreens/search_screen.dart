// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servemandu_users_app/models/sellers.dart';
import 'package:servemandu_users_app/widgets/sellers_design.dart';

class SearchScreen extends StatefulWidget {
  
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  //storing the search value in a document 
  Future<QuerySnapshot>? serviceDocList;
  String sellerNameText = ""; //creating variable for onTap function of search icon

  // method for searching the query
    //Here, we don't need to make the function asynchronous as we don't need to await for the result from the firestore. 
    //If the query matches, it'll immediately display the service below.
  initSearchingService(String textEntered)
  {
    serviceDocList = FirebaseFirestore.instance
      .collection("sellers")
      .where("sellerName", isGreaterThanOrEqualTo: textEntered)
      .get();
  }

  @override
  Widget build(BuildContext context) 
  {
   return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.blueGrey,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
      ),

      title: TextField(
        onChanged: (textEntered)
        {
          // this function updates the changes made on the text entered at the real time
          setState(() {
            sellerNameText = textEntered; //passing textEntered to the onTap() as variable
          });
          // searching field for query
          initSearchingService(textEntered);
        },

        decoration: InputDecoration(
          hintText: "Search Services Here...",
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: ()
            {
              //if the customer click on the search icon
              initSearchingService(sellerNameText);
            }, 
            icon: const Icon(Icons.search),
            color: Colors.white,
        ),
      ),

      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
   ),
    
    body: FutureBuilder<QuerySnapshot>(
      future: serviceDocList,
      builder: (context, snapshot)
      {
        return snapshot.hasData //check if there's service as per the text entered
            ? ListView.builder(//if yes, display
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index)
                {
                  Sellers model = Sellers.fromJson
                    (
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    );

                  return SellersDesignWidget(
                    model: model,
                    context: context,
                  );
                },
            ) 
            : const Center(child: Text("No Record Found"), //if no, display this text
            );
      },
    ),
    );
  }
}