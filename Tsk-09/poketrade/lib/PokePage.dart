import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class AllPokemonPage extends StatefulWidget {
  const AllPokemonPage({super.key});

  @override
  State<AllPokemonPage> createState() => _PokePageState(); // Use a proper State class name
}

class _PokePageState extends State<AllPokemonPage> {
  List<Map<String, dynamic>> pokemonData = [];
  @override
  void initState() {
    super.initState();
    fetchData();
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
  
  
  
  Future<void> fetchData() async {
    final url = 'https://pokeapi.co/api/v2/pokemon?limit=-1';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        for (var i in jsonData['results']) {
          await fetchPokeData(i['url']);
        }
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
          );
        },
      ),
    );
  }
}
