import 'package:flutter/material.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/movie_page.dart';
import 'dart:async';

class BigMovieCard extends StatefulWidget {
  final AsyncSnapshot<List<Movie>> snapshot;

  const BigMovieCard({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  _BigMovieCardState createState() => _BigMovieCardState();
}

class _BigMovieCardState extends State<BigMovieCard> {
  late final PageController _pageController;
  int _numPages = 0; // Variable to track the number of pages
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Start the timer when the widget is initialized
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageController.page == _numPages - 1) {
        // If the current page is the last page, go back to the first page
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } else {
        // Otherwise, go to the next page
        _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.snapshot.data;

    if (movies == null || movies.isEmpty) {
      return Center(
        child: Text('No'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'For you',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _buildBigMoviesCard(context, movies[index]);
            },
            onPageChanged: (int index) {
              // Update the current page when a new page is selected
              setState(() {
                _numPages = movies.length;
              });
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          child: PageIndicator(
            controller: _pageController,
            itemCount: movies.length,
          ),
        ),
      ],
    );
  }

  Widget _buildBigMoviesCard(BuildContext context, Movie movie) {
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
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            '${Constants.imagePath}${movie.posterPath}',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class PageIndicator extends AnimatedWidget {
  final PageController controller;
  final int itemCount;

  PageIndicator({required this.controller, required this.itemCount})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.page == index ? Colors.white : Colors.white54,
            ),
          );
        },
      ),
    );
  }
}
