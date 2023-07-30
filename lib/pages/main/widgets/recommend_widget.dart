import 'package:flutter/material.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/movie_page.dart';

class RecommendWidget extends StatelessWidget {
  final AsyncSnapshot<List<Movie>> snapshot;

  const RecommendWidget({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final recommendedMovies = snapshot.data;

    if (recommendedMovies == null || recommendedMovies.isEmpty) {
      return Text(
        'Error: ${snapshot.data}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    }
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 150,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: recommendedMovies.map((movie) {
                return _buildUpcomingMovieCard(context, movie);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildUpcomingMovieCard(BuildContext context, Movie movie) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePage(
              movie: movie,
              movieId: movie.id,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            '${Constants.imagePath}${movie.poster_path}', // Use the constructed image URL
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
