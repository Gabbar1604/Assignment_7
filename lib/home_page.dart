import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokepedia/Auth/login_page.dart';
import 'package:pokepedia/details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pokipedia = [];

  final Map<String, Color> typeColors = {
    'Grass': Color(0xFF78C850),
    'Fire': Color(0xFFF08030),
    'Water': Color(0xFF6890F0),
    'Bug': Color(0xFFA8B820),
    'Normal': Color(0xFFA8A878),
    'Poison': Color(0xFFA040A0),
    'Electric': Color(0xFFF8D030),
    'Ground': Color(0xFFE0C068),
    'Fairy': Color(0xFFEE99AC),
    'Fighting': Color(0xFFC03028),
    'Psychic': Color(0xFFF85888),
    'Rock': Color(0xFFB8A038),
    'Ghost': Color(0xFF705898),
    'Ice': Color(0xFF98D8D8),
    'Dragon': Color(0xFF7038F8),
    'Dark': Color(0xFF705848),
    'Steel': Color(0xFFB8B8D0),
    'Flying': Color(0xFFA890F0),
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final url = Uri.https(
      "raw.githubusercontent.com",
      "/Biuni/PokemonGO-Pokedex/master/pokedex.json",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          pokipedia = decoded["pokemon"];
        });
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                  title: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                    // Add your logout logic here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Logged out')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.menu, size: 35, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 45),
                const Text(
                  "Pokepedia",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: PokemonSearchDelegate(
                        pokipedia: pokipedia,
                        typeColors: typeColors,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search, size: 30, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: pokipedia.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.95,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                      itemCount: pokipedia.length,
                      itemBuilder: (context, index) {
                        final poke = pokipedia[index];
                        final name = poke['name'] ?? 'Unknown';
                        final imageUrl = poke['img'] ?? '';
                        final type =
                            (poke['type'] != null && poke['type'].isNotEmpty)
                            ? poke['type'][0]
                            : 'Unknown';
                        final bgColor =
                            typeColors[type] ?? Colors.grey.shade300;

                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Flexible(
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    type,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Expanded(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.fill,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              color: Colors.white,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokeDetails(
                                  tag: index,
                                  pokedetails: pokipedia[index],
                                  color: bgColor,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this class to enable search functionality
class PokemonSearchDelegate extends SearchDelegate {
  final List pokipedia;
  final Map<String, Color> typeColors;

  PokemonSearchDelegate({required this.pokipedia, required this.typeColors});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = pokipedia
        .where(
          (poke) => poke['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();

    return _buildResultList(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = pokipedia
        .where(
          (poke) => poke['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();

    return _buildResultList(context, suggestions);
  }

  Widget _buildResultList(BuildContext context, List results) {
    if (results.isEmpty) {
      return Center(child: Text('No Pokémon found'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final poke = results[index];
        final name = poke['name'] ?? 'Unknown';
        final imageUrl = poke['img'] ?? '';
        final type = (poke['type'] != null && poke['type'].isNotEmpty)
            ? poke['type'][0]
            : 'Unknown';
        final bgColor = typeColors[type] ?? Colors.grey.shade300;

        return ListTile(
          leading: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.broken_image, color: Colors.grey),
          ),
          title: Text(name),
          subtitle: Text(type),
          tileColor: bgColor.withOpacity(0.2),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokeDetails(
                  tag: pokipedia.indexOf(poke),
                  pokedetails: poke,
                  color: bgColor,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
