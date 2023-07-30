import 'dart:convert';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:http/http.dart' as http;

class Api{
  static const upcomingUrl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';

  Future<List<Movie>> getUpcomingMovies() async{
    final response = await http.get(Uri.parse(upcomingUrl));
    if (response.statusCode == 200){
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }
}

