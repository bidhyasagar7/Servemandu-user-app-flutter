// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servemandu_users_app/assistantMethods/address_changer.dart';
import 'package:servemandu_users_app/mainScreens/placed_order_screen.dart';
import 'package:servemandu_users_app/maps/maps.dart';
import 'package:servemandu_users_app/models/address.dart';

class AddressDesign extends StatefulWidget {
  const AddressDesign({Key? key, this.model, this.currentIndex, this.value, this.addressID, this.totalAmount, this.sellerUID}) : super(key: key);

  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID; 

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        //select this address
        Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value); //first address i.e., automatically selected 
      },
      child: Card(
        color: Colors.blueGrey.withOpacity(0.4),
        child: Column(
          children: [
            // address info
            Row(
              children: [
                // choosing address from multiple addresses provided by the user
                Radio(
                  value: widget.value!, 
                  groupValue: widget.currentIndex!, 
                  activeColor: Colors.amber,
                  onChanged: (val)
                  {
                    //provider
                    Provider.of<AddressChanger>(context, listen: false).displayResult(val);
                    print(val);
                  },
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text(
                                "Name: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.name.toString()),
                            ],
                          ),

                          TableRow(
                            children: [
                              const Text(
                                "Phone Number: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.phoneNumber.toString()),
                            ],
                          ),

                          TableRow(
                            children: [
                              const Text(
                                "Flat Number: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.flatNumber.toString()),
                            ],
                          ),

                          TableRow(
                            children: [
                              const Text(
                                "City: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.city.toString()),
                            ],
                          ),

                          TableRow(
                            children: [
                              const Text(
                                "State/Country: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.state.toString()),
                            ],
                          ),

                          TableRow(
                            children: [
                              const Text(
                                "Full Address: ",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.fullAddress.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //Button for Checking address on Maps
            ElevatedButton(
              onPressed: ()
              {
                MapsUtilities.openMapWithPosition(widget.model!.lat!, widget.model!.lng!);

                //opening map with full address
                //MapsUtilities.openMapWithAddress(widget.model!.fullAddress!);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black54,
              ), 
              child: const Text("Check on Maps"),
            ),

            //Button for choosing among different addresses
            widget.value == Provider.of<AddressChanger>(context).count
              ? ElevatedButton(
                onPressed: ()
                {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (c) => PlacedOrderScreen(
                        addressID: widget.addressID,
                        totalAmount: widget.totalAmount,
                        sellerUID: widget.sellerUID,
                      )));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ), 
                child: const Text("Proceed"),
                )
              : Container(),
          ],
        ),
      ),
    );
  }
}