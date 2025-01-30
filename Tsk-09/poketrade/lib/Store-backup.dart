import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:poketrade/main.dart';

class e extends StatefulWidget {
  final VoidCallback updateUser;
  const e({super.key,required this.updateUser});
  @override
  State<e> createState() => eState(); // Use a proper State class name
}

class eState extends State<e> {
  List<Map<String, dynamic>> pokemonData = [];
  bool showCard=false;
  bool gettingPurchase = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pokemonData.clear();
  }

  Widget Loading() {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 2),
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


  
  Future<void> GetCard(int price,String type) async {
    setState(() {
      pokemonData=[];
      gettingPurchase=true;
    });
    final url = 'http://127.0.0.1:8080/store';
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'user': MyHomePage.user['name'],
        'price': price,
        'type':type
      });
      final response = await http.post(Uri.parse(url),headers: header,body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        for(var i in jsonData['cards']){
          fetchPokeData(i);
        }
        setState(() {
          MyHomePage.user = jsonData['user'];
          widget.updateUser();
          showCard=true;
          gettingPurchase=false;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  Future<void> fetchPokeData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          pokemonData.add(jsonData);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Pokémon data: $e');
    }
  }
  LinearGradient GetCardCol(int lvl)
  {
    if(lvl < 100){
      return LinearGradient(
        colors: [
          Color.fromARGB(255, 122, 122, 121),
          Color.fromARGB(255, 158, 157, 157),
          Color.fromARGB(255, 159, 158, 157),
          Color.fromARGB(255, 191, 191, 189)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    else if(lvl < 200){
      return LinearGradient(
        colors: [
          Color.fromARGB(255, 128, 74, 0),
          Color.fromARGB(255, 137, 94, 26),
          Color.fromARGB(255, 156, 122, 60),
          Color.fromARGB(255, 176, 141, 87)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    else{
      return LinearGradient(
        colors: [
          Colors.yellow,
          Colors.orangeAccent,
          Colors.yellow.shade300,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double imageScale = screenWidth / 2;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 50,
                children: [
                  Text(
                  "Choose your Pack",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min, // Adjusts to fit content size
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/Card - 1.png',
                          width: imageScale,
                          height: imageScale,
                          fit: BoxFit.contain,
                        ),
                        onTap: ()=>{GetCard(200,'common')},
                      ),
                      Text(
                        "Common Card Set",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Cost-200",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Chances: Common-97% Rare-2% Legendary-1%",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/Card - 2.png',
                          width: imageScale,
                          height: imageScale,
                          fit: BoxFit.contain,
                        ),
                        onTap: ()=>{GetCard(380,'rare')},
                      ),
                      Text(
                        "Rare Card Set",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Cost-380",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "Chances: Common-67% Rare-28% Legendary-5%",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/Card - 3.png',
                          width: imageScale,
                          height: imageScale,
                          fit: BoxFit.contain,
                        ),
                        onTap: ()=>{GetCard(550,'legend')},
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "Legendary Card Set",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Cost-550",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "Chances: Common-22% Rare-50% Legendary-28%",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if(gettingPurchase && !showCard)
            Center(child: Loading(),),
          if(showCard)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 45, 88, 205),
                      Color.fromARGB(255, 46, 74, 165),
                      Color.fromARGB(255, 60, 73, 156),
                      Color.fromARGB(255, 87, 105, 176)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "YOU FOUND",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(
                      height: 230,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 48,
                        ),
                        itemCount: pokemonData.length,
                        itemBuilder: (context, index) {
                          final pokemon = pokemonData[index];
                          return Card(
                            elevation: 3,
                            child: Container(
                              decoration: BoxDecoration(gradient: GetCardCol(pokemon['base_experience'])),
                              child: Column(
                                children: [
                                  pokemon['sprites']['other']['official-artwork']
                                  ['front_default'] !=
                                      null
                                      ? Image.network(
                                    pokemon['sprites']['other']['official-artwork']
                                    ['front_default'],
                                    width: 100,
                                    height: 100,
                                  )
                                      : const CircularProgressIndicator(),
                                  Text(
                                    "${pokemon['name'][0].toUpperCase()}${pokemon['name'].substring(1).toLowerCase()}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(onPressed: ()=>{setState(() {showCard = false;})},
                    style:ElevatedButton.styleFrom(
                        fixedSize: Size(190,40),
                        elevation: 2,
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.blue,
                      ), child: Text(
                      "CLOSE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                    SizedBox(height: 5,)
                  ],
                ),
              )
            )
        ],
      ),
    );
  }
}