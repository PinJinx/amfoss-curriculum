import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poketrade/Account.dart';
import 'package:poketrade/Collection.dart';
import 'package:poketrade/Login.dart';
import 'package:poketrade/PokePage.dart';
import 'package:poketrade/Store.dart';
import 'package:poketrade/Trade.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  static Map<String, dynamic> user = {};
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}





class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> PokemonData = [];
  @override
  void initState() {
    super.initState();
  }

  void UpdateUser(){
    setState(() {
      displayUser=MyHomePage.user;
    });
  }

  Map<String, dynamic> displayUser={};
  @override
  Widget build(BuildContext context) {
    final List<Widget> _page = [
      const CollectionPage(),
      const CollectionPage(),
      StorePage(updateUser: UpdateUser),
      TradePage(updateuser: UpdateUser),
      AccountPage(updtuser: UpdateUser,)
    ];
    if(selectedIndex != 0){
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black12,
          backgroundColor: Colors.red,
          scrolledUnderElevation: 1.5,
          flexibleSpace:  Container(
          color: Colors.red, // Adjust background color as needed
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Side - Icons and spacing
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/AppBar.svg',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10), // Space between the two icons
                    SvgPicture.asset(
                      'assets/AppBar2.svg',

                      width:  MediaQuery.of(context).size.width * 0.3>160?300:MediaQuery.of(context).size.width * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Text(
                        displayUser['money'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between text and coin image
                      Image.asset(
                        'assets/Coin.png',
                        width: 30, // Adjust to scale better
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
        body: _page[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Image.asset('assets/Collection.png',width: 30, height: 30,), label: "My Collection"),
            BottomNavigationBarItem(icon: Image.asset('assets/Store.png',width: 30, height: 30,), label: "Store"),
            BottomNavigationBarItem(icon: Image.asset('assets/arrow.png',width: 30, height: 30,), label: "Trade"),
            BottomNavigationBarItem(icon: Image.asset('assets/Account.png',width: 30, height: 30), label: "Account"),
          ],
          type: BottomNavigationBarType.fixed,
          elevation: 1,
          backgroundColor: Colors.red,
          selectedFontSize: 15,
          selectedItemColor: Colors.white,
          unselectedFontSize: 14,
          unselectedItemColor: Colors.white70,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          onTap: (index){
            setState(() {
              selectedIndex = index+1;
            });
          },
        ),
      );
    }
    else{
      return Scaffold(
        body: LoginPage(onLoginSucess: (){
          setState(() {
            selectedIndex = 1;
            displayUser = MyHomePage.user;
          });
        }),
      );
    }

  }



  
  }

