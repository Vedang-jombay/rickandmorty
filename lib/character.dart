class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String lastKnownLocation;
  final String firstKnownLocation;
  final List<String> episodeUrls;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.lastKnownLocation,
    required this.firstKnownLocation,
    required this.episodeUrls,
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
      episodeUrls: List<String>.from(json['episode']),
    );
  }
}
