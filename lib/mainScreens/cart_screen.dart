// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servemandu_users_app/assistantMethods/assistant_methods.dart';
import 'package:servemandu_users_app/assistantMethods/cart_service_counter.dart';
import 'package:servemandu_users_app/assistantMethods/total_amount.dart';
import 'package:servemandu_users_app/mainScreens/address_screen.dart';
//import 'package:servemandu_users_app/mainScreens/items_screen.dart';
import 'package:servemandu_users_app/models/items.dart';
import 'package:servemandu_users_app/splashScreen/splash_screen.dart';
import 'package:servemandu_users_app/widgets/cart_service_design.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';
import 'package:servemandu_users_app/widgets/text_widget_header.dart';

class CartScreen extends StatefulWidget {
  
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

 // List<int>? seperateServiceQuantityList;
 num totalAmount = 0;

 //Displaying Service quantity on screen
   @override
   void initState() {
     super.initState();

     totalAmount = 0; // Initially total amount = 0
     Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

  //   seperateServiceQuantityList = seperateServiceQuantity();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      flexibleSpace: Container(
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
      ),

      //To go back to HomeScreen page
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: ()
        {
         // clearCartNow(context);
         Navigator.pop(context);
        },
      ),

      //Title of the page
      title: const Text(
        "Home Solutions",
        style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
      ),

      centerTitle: true,

      automaticallyImplyLeading: true,

      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.cyan),
              onPressed: ()
              {
                //already on cart screen
                print("Clicked!");
              },
            ),

            // cart icon at the appbar
            Positioned(
              child: Stack(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),

                  //displaying number of services selected
                  Positioned(
                    top: 3,
                    right: 4,
                    child: Center(
                      child: Consumer<CartServiceCounter>(
                        builder: (context,  counter, c)
                        {
                          return Text(
                            counter.count.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12)
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),

      floatingActionButton: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 10,),

          // clear cart button
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: ()
              {
                //clearing the cart
                clearCartNow(context);

                Navigator.push(context, MaterialPageRoute(builder: ((c) => const MySplashScreen())));

                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },

              label: const Text("Clear Cart", style: TextStyle(fontSize: 16),),
              backgroundColor: const Color.fromARGB(255, 16, 74, 104),
              icon: const Icon(Icons.clear_all),
              ),        
          ),

          // check out button
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              onPressed: ()
              {
                //checking out
                // here user will be sent to address page
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (c)=> AddressScreen(

                      // passing Total amount & Service Provider UID
                      totalAmount: totalAmount.toDouble(),
                      sellerUID: widget.sellerUID,  
                    ),
                  ),
                );
              },
              
              label: const Text("Check Out", style: TextStyle(fontSize: 16),),
              backgroundColor: const Color.fromARGB(255, 16, 74, 104),
              icon: const Icon(Icons.navigate_next,),
            ),  
          ),
        ],
      ),
      
      body: CustomScrollView(
        slivers: [

          //overall total amount
          SliverPersistentHeader(
            pinned: true, 
            delegate: TextWidgetHeader(title: "My Cart List")
            ),

            SliverToBoxAdapter(

              // check if cart is empty 
              child: Consumer2<TotalAmount, CartServiceCounter>(builder: (context, amountProvider, cartProvider, c)
              {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: cartProvider.count == 0 
                    ? Container() // if yes, so empty container
                    : Text(
                      "Total Price: Rs. ${amountProvider.tAmount.toString()}", // else, so total price
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ), 
                    ),
                  ),
                );
              }),
            ),

          //display selected services with quantity number from the firestore
          StreamBuilder<QuerySnapshot>
          (stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: seperateServiceIDs())
                .orderBy("publishedDate", descending: false)
                .snapshots(),
           builder: (context, snapshot)
           {
            //checking if their is service in the userCart of the firestore
            return !snapshot.hasData 

                // loading till display
                ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)

                // if empty
                : snapshot.data!.docs.isEmpty 

                ? //start building cart()
                    Container()
                  // or
                : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index)
                  {
                    Items model = Items.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    );

                    // calculating total amount
                    if(index == 0)
                    {
                      totalAmount = 0;
                      totalAmount = totalAmount + (model.price!);
                    }

                    else
                    {
                      totalAmount = totalAmount + (model.price!);
                    }

                    // updating the total amount at real time
                    if(snapshot.data!.docs.length - 1 == index) // -1 removes garbage value
                    {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) 
                      { 
                        Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                      });
                    }

                    return CartServiceDesign(
                      model: model,
                      context: context,
                      //quanNo: seperateServiceQuantityList![index],
                    );
                  },
                  
                  // removing the error related with length of the cart screen
                  childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,

                ),
              );
           },
          )
        ],
      ),
    );
  }
}