// ignore_for_file: sized_box_for_whitespace, library_private_types_in_public_api, prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:servemandu_users_app/assistantMethods/assistant_methods.dart';
//import 'package:servemandu_users_app/authentication/auth_screen.dart';
//import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/models/sellers.dart';
import 'package:servemandu_users_app/widgets/sellers_design.dart';
import 'package:servemandu_users_app/widgets/my_drawer.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  final items = [
    "slider/0.png",
    "slider/1.png",
    "slider/2.png",
    "slider/3.png",
    "slider/4.png",
    "slider/5.png",
    "slider/6.png",
    "slider/7.png",
    "slider/8.png",
    "slider/9.png",
    "slider/10.png",
    "slider/11.png",
    "slider/12.png",
    "slider/13.jpg",
    "slider/14.png",
    "slider/15.png",
    "slider/16.png",
    "slider/17.png",
    "slider/18.png",
    "slider/19.png",
    "slider/20.png",
    "slider/21.png",
    "slider/22.png",
    "slider/23.png",
    "slider/24.png",
    "slider/25.png",
    "slider/26.png",
    "slider/27.png",
  ];

  @override
  void initState() {
    
    super.initState();

    clearCartNow(context);
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
                  Colors.blueGrey,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
      
        title: Text(
          "Servemandu",
          style: const TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .3,
                    aspectRatio: 16/9,
                    //viewportFraction: 0.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.decelerate,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: items.map((index) {
                    return Builder(builder: (BuildContext content){
                      return Container(
                       width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),

                        // Black border around slider images
                        // decoration: const BoxDecoration(
                        //   color: Colors.black,
                        // ),

                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(index,
                          fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            )
          ),
          StreamBuilder<QuerySnapshot>(

            // To retrieve data from the firestore we require 3 things: model class (sellers.dart), model design (sellers_design.dart) & query.

            //Query to retrieve all service providers from sellers app
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .snapshots(),
            builder: (context, snapshot)
              {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index)
                        {
                          Sellers sModel = Sellers.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>
                          );

                          // //design for displaying sellers services
                           return SellersDesignWidget(
                             model: sModel,
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
