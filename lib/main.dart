import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poke_app/pokemondetail.dart';
import 'dart:convert';
import 'pokemon.dart';

void main() => runApp(MaterialApp(
      title: "Poke App",
      home: HomePage(),
      // for removing the banner on the top
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

  // fetchin data during init
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // user doesnt have to wait the data to be fetched using async
  // till that time we can show circular buffer
  fetchData() async {
    var res = await http.get(url);
    //decoding json with the help of dart convert
    var decodedJson = jsonDecode(res.body);
    // get the decoded json and pass it to the pokemon class
    pokeHub = PokeHub.fromJson(decodedJson);

    // whenever there is data change we must reflect to the ui so
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poke App"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              // since the pokehub is null when ui gets it so we add circle progress till everything is loaded
              children: pokeHub.pokemon
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PokeDetail(pokemon: poke,)));
                          },
                          child: Hero(
                            //assiging a tag to every pokemon by its image
                            tag: poke.img,
                            child: Card(
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(poke.img))),
                                  ),
                                  Text(
                                    poke.name,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.refresh),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
