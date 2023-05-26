// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:servemandu_users_app/assistantMethods/assistant_methods.dart';
import 'package:servemandu_users_app/models/items.dart';
import 'package:servemandu_users_app/widgets/app_bar.dart';
// import 'package:number_inc_dec/number_inc_dec.dart';


class ItemDetailsScreen extends StatefulWidget
{
  final Items? model;
  ItemDetailsScreen({this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {

  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      
      //passing seller UID for reference
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //Displaying the service image
          Image.network(widget.model!.thumbnailUrl.toString()),

          //Displaying the number of times the service is selected for
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: NumberInputPrefabbed.roundedButtons(
          //     controller: counterTextEditingController,
          //     incDecBgColor: Colors.amber,
          //     min: 1,
          //     max: 3,
          //     initialValue: 1,
          //     buttonArrangement: ButtonArrangement.incRightDecLeft,
          //   ),
          // ),

          const SizedBox(height: 20,),

          //Displaying the title of the service
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),

          //Displaying the description about the service
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
            ),
          ),

          //Displaying the price of the service
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              // ignore: prefer_interpolation_to_compose_strings
              "Rs. " + widget.model!.price.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),

          const SizedBox(height: 20,),

          //Adding the service to the cart
          Center(
            child: InkWell(
              onTap: ()
              {
                //1. Check if service already exist in the cart
                List<String> seperateServiceIDsList = seperateServiceIDs();
                seperateServiceIDsList.contains(widget.model!.itemID) ?
                
                    // if exists, inform user
                      Fluttertoast.showToast(msg: "Service is already in cart.")
                // else
                    //2. add to cart
                   : addToCart(widget.model!.itemID, context,);
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin:  FractionalOffset(0.0, 0.0),
                      end:  FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )
                ),

                width: MediaQuery.of(context).size.width -40,
                height: 50,
                child: const Center(
                child: Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
