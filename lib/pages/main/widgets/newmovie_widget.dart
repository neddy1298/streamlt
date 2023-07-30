import 'package:flutter/material.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/movie_page.dart';

class NewMovieWidget extends StatelessWidget {
  final AsyncSnapshot<List<Movie>> snapshot;

  const NewMovieWidget({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final newMovies = snapshot.data;

    if (newMovies == null || newMovies.isEmpty) {
      return const Center(
        child: Text('No new movies'),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'New Movies',
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
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: newMovies.map((movie) {
                return _buildNewMovieCard(context, movie);
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _buildNewMovieCard(BuildContext context, Movie movie) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePage(
              movie: movie,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        // onTap: () => MoviePage(),

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
