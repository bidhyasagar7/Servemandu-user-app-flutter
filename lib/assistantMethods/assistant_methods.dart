// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servemandu_users_app/assistantMethods/cart_service_counter.dart';
import 'package:servemandu_users_app/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// checking for orders
seperateOrderServiceIDs(orderIDs)
{
  List<String> seperateServiceIDsList=[], defaultServiceList=[];
  int i=0;
  
  // get order placed service Ids from the firestore
  defaultServiceList = List<String>.from(orderIDs);

  for(i; i<defaultServiceList.length; i++)
  {
    //5666777:1 (serviceID : No. of service)
    String item = defaultServiceList[i].toString();
    //var pos = item.lastIndexOf(":"); 

    //5666777
    //String getItemId = (pos != -1) ? item.substring(0, pos) : item;
    String getServiceId = item;
    print("\nThis is serviceID now = " + getServiceId);

    seperateServiceIDsList.add(getServiceId);
  }

  print("\nThis is Services List now = ");
  print(seperateServiceIDsList);

  return seperateServiceIDsList;
}

// checking if item already exists in the cart
seperateServiceIDs()
{
  List<String> seperateServiceIDsList=[], defaultServiceList=[];
  int i=0;
  
  // get services already present in the cart 
  defaultServiceList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultServiceList.length; i++)
  {
    //5666777:1 (serviceID : No. of service)
    String item = defaultServiceList[i].toString();
    //var pos = item.lastIndexOf(":"); 

    //5666777
    //String getItemId = (pos != -1) ? item.substring(0, pos) : item;
    String getServiceId = item;
    print("\nThis is serviceID now = " + getServiceId);

    seperateServiceIDsList.add(getServiceId);
  }

  print("\nThis is Services List now = ");
  print(seperateServiceIDsList);

  return seperateServiceIDsList;
}


// adding to cart
addToCart(String? serviceId, BuildContext context)
{
  // creating a list in User's cart
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add(serviceId!);

  // storing in firestore
  FirebaseFirestore.instance.collection("users")
      .doc(firebaseAuth.currentUser!.uid).update({
    "userCart": tempList,
  }).then((value)
  {
    //service added successfully notification
    Fluttertoast.showToast(msg: "Service Added Successfully!");

    sharedPreferences!.setStringList("userCart", tempList);

    // update the badge
    Provider.of<CartServiceCounter>(context, listen: false).displayCartListServiceNumber();

  });
}

// clearing cart function
clearCartNow(context)
{
  //all services from cart are removed except the garbage value; set cart to be empty
  sharedPreferences!.setStringList("userCart", ["garbagevalue"]);

  //get empty cart in our local storage
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  //updating firestore database
  FirebaseFirestore.instance
  .collection("users")
  .doc(firebaseAuth.currentUser!.uid)
  .update({"userCart": emptyList}).then((value) // updating cart list
  {
    // checking if the empty cart list is stored locally
    sharedPreferences!.setStringList("userCart", emptyList!);

    // updating the badge
    Provider.of<CartServiceCounter>(context, listen: false).displayCartListServiceNumber();
    // context helps to find from which page/service clearCartNow() is called
   
  });
}

// seperate service ordered quantity
//seperateOrderServiceQuantities(orderIDs)
// {
//   List<String> seperateServiceQuantityList=[];
//   List<String> defaultServiceList=[];
//   int i=0;
  
//   // get services already present in the cart 
//   defaultServiceList = List<String>.from(orderIDs);

//   for(i; i<defaultServiceList.length; i++)
//   {
//     //5666777:1 (serviceID : No. of service)
//     String item = defaultServiceList[i].toString();
    
       //Splitting helps to find the number of same service ordered by the user
//     //1; 

      // String item = defaultServiceList[i].toString();
      
//     List<String> listServiceCharacters = item.split(":").toList();

//     //quantity no. should be in integer type
//     var quanNo = int.parse(listServiceCharacters[1].toString());

//     print("\nThis is Quantity Number = " + quanNo.toString());

//     seperateServiceQuantityList.add(quanNo.toString());
//   }

//   print("\nThis is Services Quantity List now = ");
//   print(seperateServiceQuantityList);

//   return seperateServiceQuantityList;
// }


// seperate service quantity list
// seperateServiceQuantity()
// {
//   List<int> seperateServiceQuantityList=[];
//   List<String> defaultServiceList=[];
//   int i=0;
  
//   // get services already present in the cart 
//   defaultServiceList = sharedPreferences!.getStringList("userCart")!;

//   for(i; i<defaultServiceList.length; i++)
//   {
//     //5666777:1 (serviceID : No. of service)
//     String item = defaultServiceList[i].toString();
    
       //Splitting helps to find the number of same service ordered by the user
//     //1; 

      // String item = defaultServiceList[i].toString();
      
//     List<String> listServiceCharacters = item.split(":").toList();

//     //quantity no. should be in integer type
//     var quanNo = int.parse(listServiceCharacters[1].toString());

//     print("\nThis is Quantity Number = " + quanNo.toString());

//     seperateServiceQuantityList.add(quanNo);
//   }

//   print("\nThis is Services Quantity List now = ");
//   print(seperateServiceQuantityList);

//   return seperateServiceQuantityList;
// }
