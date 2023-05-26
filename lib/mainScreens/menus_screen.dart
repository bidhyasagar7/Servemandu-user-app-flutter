// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:servemandu_users_app/assistantMethods/assistant_methods.dart';
import 'package:servemandu_users_app/models/sellers.dart';
import 'package:servemandu_users_app/splashScreen/splash_screen.dart';
import 'package:servemandu_users_app/widgets/menus_design.dart';
import 'package:servemandu_users_app/widgets/text_widget_header.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';
import 'package:servemandu_users_app/models/menus.dart';
//import 'package:servemandu_users_app/global/global.dart';
//import 'package:servemandu_users_app/widgets/sellers_design.dart';


class MenusScreen extends StatefulWidget
{
  final Sellers? model;
  MenusScreen({this.model});

  @override
  _MenusScreenState createState() => _MenusScreenState();
}



class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.blueGrey,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),

        // This can be edited because it'll remove the service from the cart of the user if they go back
        leading: IconButton(
          onPressed: () 
          {
            clearCartNow(context);

            Navigator.push(context, MaterialPageRoute(builder: ((c) => const MySplashScreen())));

          }, 
          icon: Icon(Icons.arrow_back)
          ),
        //
        
        title: const Text(
          "Home Solutions",
          style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),

        centerTitle: true,
        automaticallyImplyLeading: true,
      ),

      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true, delegate: TextWidgetHeader(title: widget.model!.sellerName.toString() + " Services")),
          StreamBuilder<QuerySnapshot>(

            //Displaying data from firestore through menus.dart (model class), menus_design.dart (model design) & query.

            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  Menus model = Menus.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return MenusDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
