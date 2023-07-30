// ignore_for_file: non_constant_identifier_names

class Movie {
  int id;
  String title;
  String original_title;
  String backdrop_path;
  String poster_path;
  String overview;
  String release_date;
  dynamic vote_average;
  // String genre_id;

  Movie({
    required this.id,
    required this.title,
    required this.original_title,
    required this.backdrop_path,
    required this.poster_path,
    required this.overview,
    required this.release_date,
    required this.vote_average,
    // required this.genre_id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      title: json["title"],
      original_title: json["original_title"],
      backdrop_path: json["backdrop_path"],
      poster_path: json["poster_path"],
      overview: json["overview"],
      release_date: json["release_date"],
      vote_average: json["vote_average"],
      // genre_id: json["genre_id"],
    );
  }
}
