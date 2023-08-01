import 'package:flutter/material.dart';
import 'package:streamlt/api/api.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/widgets/customnavbar.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // back to the previous page
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Discover',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<MovieCategory>>(
                future: _fetchMovieCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final categories = snapshot.data ?? [];
                    return Column(
                      children: categories
                          .map((category) => CategoryList(
                                title: category.title,
                                posterPath: category.movies.isNotEmpty
                                    ? category.movies.first.poster_path
                                    : '',
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }

  Future<List<MovieCategory>> _fetchMovieCategories() async {
    final latestMovies = await Api().getMovies('now_playing');
    final popularMovies = await Api().getMovies('popular');
    final topRatedMovies = await Api().getMovies('top_rated');
    final upcomingMovies = await Api().getMovies('upcoming');

    return [
      MovieCategory(title: 'New Release', movies: latestMovies),
      MovieCategory(title: 'Popular', movies: popularMovies),
      MovieCategory(title: 'Top Rated', movies: topRatedMovies),
      MovieCategory(title: 'Upcoming', movies: upcomingMovies),
    ];
  }
}

class MovieCategory {
  final String title;
  final List<Movie> movies;

  MovieCategory({required this.title, required this.movies});
}

class CategoryList extends StatelessWidget {
  CategoryList({
    Key? key,
    required this.title,
    required this.posterPath,
  }) : super(key: key);

  final String title;
  final String posterPath;

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'https://image.tmdb.org/t/p/w500$posterPath';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 70,
                    width: 90,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 23,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
