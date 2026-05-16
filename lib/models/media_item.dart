class MediaItem {
  final String id;
  final String title;
  final String year;
  final String genre;
  final String duration; // e.g. "2h 16m" for movies, "8 seasons" for shows
  final String description;
  final String imagePath;
  final double imdbScore;
  final String type; // 'movie' or 'tvshow'
  bool isInMyList;
  bool isWatched;
  double? userScore; // 1–10, null if not rated

  MediaItem({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.duration,
    required this.description,
    required this.imagePath,
    required this.imdbScore,
    required this.type,
    this.isInMyList = false,
    this.isWatched = false,
    this.userScore,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'year': year,
    'genre': genre,
    'duration': duration,
    'description': description,
    'imagePath': imagePath,
    'imdbScore': imdbScore,
    'type': type,
    'isInMyList': isInMyList ? 1 : 0,
    'isWatched': isWatched ? 1 : 0,
    'userScore': userScore,
  };

  factory MediaItem.fromMap(Map<String, dynamic> map) => MediaItem(
    id: map['id'],
    title: map['title'],
    year: map['year'],
    genre: map['genre'],
    duration: map['duration'],
    description: map['description'],
    imagePath: map['imagePath'],
    imdbScore: map['imdbScore'],
    type: map['type'],
    isInMyList: map['isInMyList'] == 1,
    isWatched: map['isWatched'] == 1,
    userScore: map['userScore'],
  );
}
