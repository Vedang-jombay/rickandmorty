import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'character.dart';

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
