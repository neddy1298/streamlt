import 'package:flutter/material.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/movie_page.dart';

class PopularMovieWidget extends StatelessWidget {
  final AsyncSnapshot<List<Movie>> snapshot;

  const PopularMovieWidget({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final popularMovies = snapshot.data;

    if (popularMovies == null || popularMovies.isEmpty) {
      return const Center(
        child: Text('No upcoming movies'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Movies',
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
          height: 10,
        ),
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: popularMovies.map((movie) {
                return _buildPopularMovieCard(context, movie);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularMovieCard(BuildContext context, Movie movie) {
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${Constants.imagePath}${movie.poster_path}', // Use the constructed image URL
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
