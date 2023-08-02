import 'package:flutter/material.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/movie_page.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final double? customSize;
  final AsyncSnapshot<List<Movie>> snapshot;

  const MovieCard({
    Key? key,
    required this.title,
    required this.snapshot,
    this.customSize,
  }) : super(key: key);

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
                  color: Colors.white54,
                  fontSize: 25,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: customSize ?? 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _buildMovieCard(context, movies[index]);
              },
            ),
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        '${Constants.imagePath}${movie.posterPath}'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.darken),
                  ),
                ),
                width: 150,
                height: customSize ?? 200,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${movie.releaseDate.substring(0, 4)}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
