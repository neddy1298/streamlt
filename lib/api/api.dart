import 'dart:convert';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:http/http.dart' as http;

class Api {
  static const getMovieUrl = 'https://api.themoviedb.org/3/movie/';

  Future<List<Movie>> getMovies(String movieType) async {
    final response = await http
        .get(Uri.parse('$getMovieUrl/$movieType?api_key=${Constants.apiKey}'));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getRecommendedMovies(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=${Constants.apiKey}'));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      final List<Movie> movies =
          decodedData.map((movie) => Movie.fromJson(movie)).toList();

      // Remove movies with any null value in any field
      movies.removeWhere((movie) => movieContainsNullValues(movie));

      return movies;
    } else {
      throw Exception('Something happened');
    }
  }

  bool movieContainsNullValues(Movie movie) {
    // Check if any field in the Movie object is null
    return movie.toJson().values.any((value) => value == null);
  }

  Future<Movie> getMovie(String movieType) async {
    final response = await http
        .get(Uri.parse('$getMovieUrl/$movieType?api_key=${Constants.apiKey}'));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return Movie.fromJson(decodedData[0]);
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?query=$query&api_key=${Constants.apiKey}'));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body)['results'] as List;
      final List<Movie> movies =
          decodedData.map((movie) => Movie.fromJson(movie)).toList();

      // Remove movies with any null value in any field
      movies.removeWhere((movie) => movieContainsNullValues(movie));

      return movies;
    } else {
      throw Exception('Something happened');
    }
  }
}
