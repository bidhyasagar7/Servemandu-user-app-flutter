import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:servemandu_users_app/assistantMethods/address_changer.dart';
import 'package:servemandu_users_app/assistantMethods/cart_service_counter.dart';
import 'package:servemandu_users_app/assistantMethods/total_amount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';
import 'splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        //updates the cart service list at real time 
        ChangeNotifierProvider(create: (c) => CartServiceCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
      ],
      
      child: MaterialApp(
        title: 'Users App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}


