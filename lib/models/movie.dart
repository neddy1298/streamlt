class Movie {
  String title;
  String original_title;
  String backdrop_path;
  String poster_path;
  String overview;
  String release_date;
  dynamic vote_average;

  Movie({
    required this.title,
    required this.original_title,
    required this.backdrop_path,
    required this.poster_path,
    required this.overview,
    required this.release_date,
    required this.vote_average,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"],
      original_title: json["original_title"],
      backdrop_path: json["backdrop_path"],
      poster_path: json["poster_path"],
      overview: json["overview"],
      release_date: json["release_date"],
      vote_average: json["vote_average"],
    );
  }
}
