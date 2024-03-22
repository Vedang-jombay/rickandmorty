import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String lastKnownLocation;
  final String firstKnownLocation;
  final List<String> episodeUrls; // Define episodeUrls

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.lastKnownLocation,
    required this.firstKnownLocation,
    required this.episodeUrls, // Add episodeUrls here
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      gender: json['gender'],
      image: json['image'],
      lastKnownLocation: json['location']['name'],
      firstKnownLocation: json['origin']['name'],
      episodeUrls: List<String>.from(json['episode']), // Parse episode URLs
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Characters',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black87,
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Character>> futureCharacters;

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchCharacters();
  }

  Future<List<Character>> fetchCharacters() async {
    Dio dio = Dio();
    try {
      Response response = await dio.get('https://rickandmortyapi.com/api/character');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data['results'];
        return jsonData.map((character) => Character.fromJson(character)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick and Morty Characters'),
      ),
      body: FutureBuilder<List<Character>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Character> characters = snapshot.data!;
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterDetailsScreen(character: characters[index]),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 150,
                    child: Card(
                      color: Colors.grey[900],
                      child: Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              characters[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  characters[index].name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: characters[index].status == 'Alive' ? Colors.green : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${characters[index].status} - ${characters[index].species}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Last known location: ${characters[index].lastKnownLocation}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'First seen in: ${characters[index].firstKnownLocation}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class CharacterDetailsScreen extends StatefulWidget {
  final Character character;

  CharacterDetailsScreen({required this.character});

  @override
  _CharacterDetailsScreenState createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late List<String> episodes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchEpisodes();
  }

  Future<void> fetchEpisodes() async {
    setState(() {
      isLoading = true;
    });

    List<String> episodeList = [];

    try {
      for (String url in widget.character.episodeUrls) {
        Response response = await Dio().get(url);
        if (response.statusCode == 200) {
          Map<String, dynamic> episodeData = response.data;
          episodeList.add(episodeData['name']);
        }
      }
    } catch (e) {
      print('Error fetching episodes: $e');
    }

    setState(() {
      episodes = episodeList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.character.image),
            SizedBox(height: 16),
            Text(
              'Name: ${widget.character.name}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Status: ${widget.character.status}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Species: ${widget.character.species}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Gender: ${widget.character.gender}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Last Known Location: ${widget.character.lastKnownLocation}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'First Seen in: ${widget.character.firstKnownLocation}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Episodes:',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: InkWell(
                      onTap: () {
                        // Handle episode link tap
                        // Example: Launch the episode link in a browser
                      },
                      child: Text(
                        episodes[index],
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


