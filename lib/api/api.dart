import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:http/http.dart' as http;

class Api {
  static const getMovieUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getMovies(String movieType) async {
    final response = await http
        .get(Uri.parse('$getMovieUrl/$movieType?api_key=${Constants.apiKey}'));
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

  Future<List<Movie>> getFavoriteMovies() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final favSnapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .where('userId', isEqualTo: user.uid)
        .get();

    if (favSnapshot.docs.isEmpty) {
      return [];
    }

    final List<int> movieIds = favSnapshot.docs.first['movieId'].cast<int>();

    final List<Movie> favoriteMovies = await Future.wait(
      movieIds.map((movieId) => getMovieById(movieId)),
    );

    return favoriteMovies;
  }

  Future<Movie> getMovieById(int movieId) async {
    final response = await http.get(
      Uri.parse('$getMovieUrl/movie/$movieId?api_key=${Constants.apiKey}'),
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return Movie.fromJson(decodedData);
    } else {
      throw Exception('Something happened');
    }
  }
}
