import 'dart:convert';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:http/http.dart' as http;

class Api{
  static const upcomingMovieUrl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';
  static const newMovieUrl = 'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';

  Future<List<Movie>> getUpcomingMovies() async{
    final response = await http.get(Uri.parse(upcomingMovieUrl));
    if (response.statusCode == 200){
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<Movie>> getNewMovies() async{
    final response = await http.get(Uri.parse(newMovieUrl));
    if (response.statusCode == 200){
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }
}

