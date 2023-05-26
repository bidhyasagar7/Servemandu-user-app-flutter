// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

// reusable dart file; used by both item_screen.dart & item_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servemandu_users_app/assistantMethods/cart_service_counter.dart';
import 'package:servemandu_users_app/mainScreens/cart_screen.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;

  //receiving passed values from items_screen and item_detail_screen
  final String? sellerUID;
  MyAppBar({this.bottom, this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar>
{
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          Navigator.pop(context);
        },
      ),

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
                //send user to cart screen
                Navigator.push(context, MaterialPageRoute(builder: (c)=>CartScreen(sellerUID: widget.sellerUID)));
              },
            ),

            Positioned(
              child: Stack(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3,
                    right: 4,
                    child: Center(
                      //displaying number of services selected
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
    );
  }
}
