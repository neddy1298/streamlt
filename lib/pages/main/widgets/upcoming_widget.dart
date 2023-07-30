import 'package:flutter/material.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/movie_page.dart';

class UpComingWidget extends StatelessWidget {
  final AsyncSnapshot<List<Movie>> snapshot;

  const UpComingWidget({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final upcomingMovies = snapshot.data;

    if (upcomingMovies == null || upcomingMovies.isEmpty) {
      return const Center(
        child: Text('No upcoming movies'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Upcoming Movies',
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
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: upcomingMovies.map((movie) {
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
