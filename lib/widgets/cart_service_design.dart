// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:servemandu_users_app/models/items.dart';

class CartServiceDesign extends StatefulWidget {
  
  final Items? model;
  BuildContext? context;
  //final int? quanNo;

  // constructor of this class
  CartServiceDesign({
    this.model,
    this.context,
    //this.quanNo,
  });

  @override
  State<CartServiceDesign> createState() => _CartServiceDesignState();
}

class _CartServiceDesignState extends State<CartServiceDesign> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: InkWell(
        splashColor: const Color.fromARGB(255, 16, 74, 104),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Row( // fetching different services in row sequence
              children: [

                //Fetching service detail              
                Image.network(widget.model!.thumbnailUrl!, width: 140, height: 120,),
                
                const SizedBox(width: 26,),

                // displaying service and its details in column form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // arranging service image and detail in cart
                  children: [

                    //SizedBox(height: 40,),
                    
                    //Displaying service name
                    Text(
                      widget.model!.title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Kiwi",
                      ),
                    ),

                    const SizedBox(height: 10,),

                    //Displaying service quantity (x 7)
                    // Row(
                    //   children: [

                      //const Text(  
                    //   "x ",
                    //   style: const TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 25,
                    //     fontFamily: "Acme",
                    //   ),
                    // ),

                        // Text(  
                    //   widget.quanNo.toString(),
                    //   style: const TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 25,
                    //     fontFamily: "Acme",
                    //   ),
                    // ),
                    //   ],
                    // )

                    //Display the price of the service
                    Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text("Price: ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),

                      const Text("Rs. ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),

                      Text(
                        widget.model!.price.toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}