// ignore_for_file: unused_field, use_key_in_widget_constructors, must_be_immutable, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/models/address.dart';
import 'package:servemandu_users_app/widgets/simple_appbar.dart';
import 'package:servemandu_users_app/widgets/text_field.dart';
import 'package:geolocator/geolocator.dart';


class SaveAddressScreen extends StatelessWidget 
{
  //making address details private
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //variable for finding longitude & latitude of user
  List<Placemark>? placeMarks;
  Position? position;

  getUserLocationAddress() async
  {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    position = newPosition;
    
    placeMarks = await placemarkFromCoordinates(
      position!.latitude, 
      position!.longitude,
    );

    // //accurate location is obtained from geocoding package
    Placemark pMark = placeMarks![0];

    String fullAddress = '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}, ${pMark.country}';

    _locationController.text = fullAddress;

    _flatNumber.text = '${pMark.subThoroughfare}, ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}';
    _city.text = '${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.postalCode}';
    _state.text = '${pMark.country}';
    _completeAddress.text = fullAddress;    
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: SimpleAppBar(title: "Servemandu",),

      floatingActionButton: FloatingActionButton.extended
      (
        onPressed: ()
        {
          //save address info
          if(_formKey.currentState!.validate())
          {
            final model = Address(
              name: _name.text.trim(),
              state: _state.text.trim(),
              fullAddress: _completeAddress.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              flatNumber: _flatNumber.text.trim(),
              city: _city.text.trim(),
              lat: position!.latitude,
              lng: position!.longitude,        
            ).toJson();

            //saving the address to firestore
            FirebaseFirestore.instance.collection("users")
            .doc(sharedPreferences!.getString("uid"))
            .collection("userAddress") // user can add many locations for providing the service
            .doc(DateTime.now().millisecondsSinceEpoch.toString()) // saves the user's location at real time
            .set(model).then((value)
            {
              Fluttertoast.showToast(msg: "New Address has been saved.");
              _formKey.currentState!.reset();
            });
          }
        },
        
        label: const Text("Save Now"),
        icon: const Icon(Icons.save_sharp),
      ),

      body: SingleChildScrollView
      (
        child: Column
        (
          children: 
          [
            const SizedBox(height: 6,),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Save Address",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.blueGrey,
                size: 35,
              ),

              title: SizedBox(
                width: 200,

                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),

                  controller: _locationController,
                  
                  decoration: const InputDecoration(
                    hintText: "What's your address?",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10,),

            ElevatedButton.icon(
              icon: const Icon(Icons.location_on, color: Colors.white,), 
              label: const Text(
                "Get my location.",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () 
              {
                //getCurrentLocation() with address
                getUserLocationAddress();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.blueGrey),
                  )
                ),
              ),
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: 'Name',
                    controller: _name,
                  ),

                  MyTextField(
                    hint: 'Phone Number',
                    controller: _phoneNumber,
                  ),

                  MyTextField(
                    hint: 'City',
                    controller: _city,
                  ),

                  MyTextField(
                    hint: 'State/Country',
                    controller: _state,
                  ),

                  MyTextField(
                    hint: 'Address Line',
                    controller: _flatNumber,
                  ),

                  MyTextField(
                    hint: 'Complete Address',
                    controller: _completeAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}