import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:poketrade/main.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _PokeCPageState(); // Use a proper State class name
}

class _PokeCPageState extends State<CollectionPage> {
  List<Map<String, dynamic>> pokemonData = [];
  @override
  void initState() {
    super.initState();
    fetchData();
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
  
  
  
  Future<void> fetchData() async {
    final url = 'http://127.0.0.1:8080/collection';
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'name':MyHomePage.user['name']
      });
      final response = await http.post(Uri.parse(url),headers: header,body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        for(var i in jsonData['collection']){
          fetchPokeData(i);
        }
      } else {
        print('Error: ${response.body}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pokemonData.isEmpty
          ? Loading()
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: pokemonData.length,
        itemBuilder: (context, index) {
          final pokemon = pokemonData[index];
          return Card(
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: GetCardCol(pokemon['base_experience'])
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      pokemon['sprites']['other']['official-artwork']
                      ['front_default'] !=
                          null
                          ? Image.network(
                        pokemon['sprites']['other']['official-artwork']
                        ['front_default'],
                        width: constraints.maxWidth * 0.8,
                        height: constraints.maxHeight * 0.8,
                      )
                          : Loading(),
                      Text(
                        "${pokemon['name'][0].toUpperCase()}${pokemon['name'].substring(1).toLowerCase()}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
