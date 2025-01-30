import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poketrade/main.dart';

class TradePage extends StatefulWidget {
  final VoidCallback updateuser;
  const TradePage({super.key,required this.updateuser});

  @override
  State<TradePage> createState() => TradePageState(); // Use a proper State class name
}

class TradePageState extends State<TradePage> {
  List<Map<String, dynamic>> pokemonData = [];
  List<Map<String, dynamic>> buyingdata = [];
  List<Map<String, dynamic>> MypokemonData = [];
  List<List<String>> buyData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchMyData();
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


  Future<void> fetchMyData() async {
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
          fetchPokeData(i,true);
        }
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  
  Future<void> fetchData() async {
    final url = 'http://127.0.0.1:8080/trade';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        for(var i in jsonData['trades']){
          setState(() {
            buyData.add([i['trader'],i['price']]);
          });
          fetchPokeData(i['url'],false);
        }
      } else {
        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchPokeData(String url,bool IsCollection) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          if(IsCollection){MypokemonData.add(jsonData);}
          else{buyingdata.add(jsonData);}});
      }
      else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Pokémon data: $e');
    }
  }

  Future<void> SellPokemon(String purl,int price) async{
    final url = 'http://127.0.0.1:8080/sell';
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'name': MyHomePage.user['name'],
        'url': purl,
        'price':price
      });
      final response = await http.post(Uri.parse(url),headers: header,body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          MyHomePage.user=jsonData['user'];
          widget.updateuser();
          MypokemonData = [];
          pokemonData = [];
          buyingdata = [];
          buyData=[];
        });
        fetchData();
        fetchMyData();
      }
      else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }




  Future<void> BuyPokemon(String purl,int price,String tname) async{
    final url = 'http://127.0.0.1:8080/buy';
    try {
      final header = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'name': tname,
        'url': purl,
        'user':MyHomePage.user['name'],
        'price':price,
        'money':MyHomePage.user['money'],
      });
      final response = await http.post(Uri.parse(url),headers: header,body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          MyHomePage.user=jsonData['user'];
          widget.updateuser();
          MypokemonData = [];
          pokemonData = [];
          buyingdata = [];
          buyData=[];
        });
        fetchData();
        fetchMyData();
      }
      else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  @override
  void dispose() {
    super.dispose();
    pokemonData.clear();
    MypokemonData.clear();
    buyingdata.clear();
    buyData.clear();
  }


  Color b2 = Colors.red;
  Color b1 = Colors.white24;


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

  bool ConfirmWidget = false;
  bool IsSelling = false;
  String SelectedURL='';
  String TraderName='';
  int SelectedPrice = 1000;
  @override
  Widget build(BuildContext context) {
    if(pokemonData.isEmpty){
      setState(() {
        if(IsSelling){
          pokemonData=MypokemonData;
        }
        else{
          pokemonData=buyingdata;
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pokemonData=[];
                  ConfirmWidget = false;
                  print(MypokemonData.length);
                  b2 = Colors.red;
                  IsSelling = false;  // Update IsSelling inside setState
                  b1 = Colors.white24;
                });
              },
              child: Text(
                'Buy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(190, 40),
                elevation: 2,
                backgroundColor: b1,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white12,
              ),
            ),

            SizedBox(
              width: 20,
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  pokemonData=[];
                  ConfirmWidget = false;
                  b1 = Colors.green;
                  IsSelling = true;
                  b2 = Colors.white24;
                });
              },
              child: Text(
                'Sell',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(190, 40),
                elevation: 2,
                backgroundColor: b2,
                foregroundColor: Colors.white,
              ),
            ),

          ],
        ),
      ),
      body: pokemonData.isEmpty
          ? Loading()
          : Stack(
        fit: StackFit.expand,
            children: [
              GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    ),
                    itemCount: pokemonData.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemonData[index];
                      return
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              SelectedURL = pokemon['location_area_encounters'].toString().replaceAll('/encounters','/');
                              ConfirmWidget = true;
                              if(!IsSelling){TraderName = buyData[index][0];}
                              SelectedPrice = pokemon['base_experience'];
                            });
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: GetCardCol(
                                      pokemon['base_experience'])
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      pokemon['sprites']['other']['official-artwork']['front_default'] !=
                                          null
                                          ? Image.network(
                                        pokemon['sprites']['other']['official-artwork']['front_default'],
                                        width: constraints.maxWidth * 0.7,
                                        height: constraints.maxHeight * 0.7,
                                      )
                                          : Loading(),
                                      pokemonData == buyingdata ?
                                      Text(
                                        "Price: ${buyData[index][1]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ) : Text(
                                        "${pokemon['name'][0]
                                            .toUpperCase()}${pokemon['name']
                                            .substring(1)
                                            .toLowerCase()}",
                                        // Access only if index is valid
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      pokemonData == buyingdata ?
                                      Text(
                                        "Trader: ${buyData[index][0]}",
                                        // Access only if index is valid
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ) : Text(
                                        "Worth: ${pokemon['base_experience']}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                    }
            ),
              if(ConfirmWidget)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                    BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                    ),
                    ],
                    ),
                    width: 300,
                    height: 200,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          IsSelling?
                        "Do you really want to sell your card?"
                          : MyHomePage.user['money'] >= SelectedPrice?"Do you really want to buy the card?":"Sorry but you can't afford that card",
                        style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            ElevatedButton(
                              onPressed: MyHomePage.user['money'] >= SelectedPrice || IsSelling
                                  ? () {
                                setState(() {
                                  ConfirmWidget = false;
                                  if (IsSelling) {
                                    SellPokemon(SelectedURL, SelectedPrice);
                                  } else {
                                    BuyPokemon(SelectedURL, SelectedPrice,TraderName);
                                  }
                                });
                              }
                                  : null,
                        child: Text("Confirm"),
                        ),
                        ElevatedButton(
                        onPressed: () {
                          setState(() {
                            ConfirmWidget = false;
                          });
                          },
                          child: Text("Cancel"),
                          ),
                        ],
                        ),
                      ],
                      ),
                    ),
                ),
              )
              )
            ]),
    );
  }
}
