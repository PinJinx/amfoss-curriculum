import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:poketrade/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key,required this.updtuser});
  final VoidCallback updtuser;
  @override
  State<AccountPage> createState() => _AccountPageState(); // Use a proper State class name
}

class _AccountPageState extends State<AccountPage> {
  List<Map<String, dynamic>> pokemonData = [];

  @override
  void initState() {
    super.initState();
  }


  Widget Loading() {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 2),
        onEnd: () {
          // Repeat the animation when it finishes
          setState(() {});
        },
        builder: (context, double value, child) {
          return Transform.rotate(
            angle: value * 2 * 3.1416, // Full rotation
            child: Image.asset(
              'assets/Pokeball.png', // Your rotating image
              width: 80,
              height: 80,
            ),
          );
        },
      ),
    );
  }


  Future<void> RegisterData(String em, String pass, String name) async {
    final url = 'http://127.0.0.1:8080/update';
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'oldem':MyHomePage.user['email'],
        'em': em,
        'pass': pass,
        'name': name
      });
      final response = await http.post(
          Uri.parse(url), headers: header, body: body);
      if (response.statusCode == 200) {
        bttontext = 'Applied';
        final Map<String, dynamic> jsonData = json.decode(response.body);
        MyHomePage.user = jsonData['user'];
        widget.updtuser();
        bT();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  void bT(){
    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        bttontext = 'Apply Changes';
      });
    });
  }

  //Register
  final TextEditingController RemailController = TextEditingController();
  final TextEditingController RpasswordController = TextEditingController();
  final TextEditingController RnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RemailController.text = MyHomePage.user['email'];
    RnameController.text = MyHomePage.user['name'];
    RpasswordController.text = MyHomePage.user['password'];
    return Scaffold(
        body: Container(child: Account(),decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffaa00ff), // Deep blue
            Color(0xff5700ff), // Vivid red
            Color(0xff151e8f), // Bright yellow/orange
            Color(0xff0b2450), // Dark purple// Deep space black
          ],
        ),),)
    );
  }


  String bttontext='Apply Changes';

  Widget Account() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

        ),
        padding: EdgeInsets.all(16), // Add padding for better spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),

            // Add spacing between elements
            Form(
              child: Column(
                children: [
                  Container(
                    width: 450,
                    child: TextFormField(
                      controller: RnameController,
                      decoration: InputDecoration(
                        hintText: "Enter Your Name:",
                        labelText: 'Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 450,
                    child: TextFormField(
                      controller: RemailController,
                      decoration: InputDecoration(
                        hintText: "Enter Your Email:",
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 450,
                    child: TextFormField(
                      controller: RpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter Your Password:",
                        labelText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                        RegisterData(RemailController.text, RpasswordController.text, RnameController.text);
                    },
                    child: Text(
                      bttontext,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(190, 40),
                      elevation: 2,
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.blue,
                    ),
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
