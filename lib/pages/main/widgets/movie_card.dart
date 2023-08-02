import 'package:flutter/material.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/movie_page.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final double? customSize;
  final AsyncSnapshot<List<Movie>> snapshot;

  const MovieCard({super.key, 
    required this.title,
    required this.snapshot,
    this.customSize,
  });

  @override
  Widget build(BuildContext context) {
    final movies = snapshot.data;

    if (movies == null || movies.isEmpty) {
      return Center(
        child: Text('No $title'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'See All',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: customSize ?? 250, // Use customSize when provided, or default to 250
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _buildMovieCard(context, movies[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie) {
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
            '${Constants.imagePath}${movie.posterPath}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
