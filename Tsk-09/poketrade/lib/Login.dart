import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:poketrade/main.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSucess;
  const LoginPage({super.key,required this.onLoginSucess});
  @override
  State<LoginPage> createState() => _LoginPageState(); // Use a proper State class name
}

class _LoginPageState extends State<LoginPage> {
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
  
  
  
  Future<void> ValidateData(String em,String pass) async {
    final url = 'http://127.0.0.1:8080/validate';
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'em': em,
        'pass': pass,
      });
      final response = await http.post(Uri.parse(url),headers: header,body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          MyHomePage.user = jsonData['user'];
          widget.onLoginSucess();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }



  Future<void> RegisterData(String em,String pass,String name) async {
    final url = 'http://127.0.0.1:8080/register';
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'em': em,
        'pass': pass,
        'name':name
      });
      final response = await http.post(Uri.parse(url),headers: header,body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          MyHomePage.user = jsonData['user'];
          widget.onLoginSucess();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Register
  final TextEditingController RemailController = TextEditingController();
  final TextEditingController RpasswordController = TextEditingController();
  final TextEditingController RnameController = TextEditingController();
  final TextEditingController RconfirmpasswordController = TextEditingController();
  bool LoginScreen=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: LoginScreen?LoginPage():RegisterPage(),
    );
  }


  Widget RegisterPage(){
    return Center(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16), // Add padding for better spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Image.asset('assets/logo.png',width: 400,),
            SizedBox(height: 20), // Add spacing between elements
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
                  SizedBox(height: 20),
                  Container(
                    width: 450,
                    child: TextFormField(
                      controller: RconfirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Re-enter Your Password:",
                        labelText: 'RePassword',
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
                      if(RpasswordController.text == RconfirmpasswordController.text){
                        RegisterData(RemailController.text, RpasswordController.text, RnameController.text);
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(190,40),
                      elevation: 2,
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(child: Text('Already Have an account? Click Here.',style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),),onTap: ()=>{setState(() {
                    LoginScreen = true;
                  })},)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget LoginPage(){
    return Center(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16), // Add padding for better spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Image.asset('assets/logo.png',width: 400,),
            SizedBox(height: 20), // Add spacing between elements
            Form(
              child: Column(
                children: [
                  Container(
                    width: 450,
                    child: TextFormField(
                      controller: emailController,
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
                      controller: passwordController,
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
                      ValidateData(emailController.text, passwordController.text);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(190,40),
                      elevation: 2,
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(child: Text('Dont have an account? Click Here.',style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),),onTap: ()=>{setState(() {
                    LoginScreen = false;
                  })},)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
