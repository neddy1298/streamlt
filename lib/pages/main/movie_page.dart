// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streamlt/api/api.dart';
import 'package:streamlt/components/constants.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/widgets/customnavbar.dart';
import 'package:streamlt/pages/main/widgets/movie_buttons.dart';
import 'package:streamlt/pages/main/widgets/recommend_widget.dart';

class MoviePage extends StatefulWidget {
  final Movie movie;
  final int movieId;

  const MoviePage({Key? key, required this.movie, required this.movieId})
      : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Movie>> recommendedMovies;
  final user = FirebaseAuth.instance.currentUser;
  bool isFavorited = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    recommendedMovies = Api().getRecommendedMovies(widget.movieId);
    checkFavoritedStatus();
  }

  void addFavMovie() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final favSnapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .where('userId', isEqualTo: user?.uid)
        .where('movieId', arrayContains: widget.movieId)
        .get();

    if (favSnapshot.docs.isEmpty) {
      await favMovieDetails();
    } else {
      final favId = favSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('favorite')
          .doc(favId)
          .update({
        'movieId': FieldValue.arrayRemove([widget.movieId]),
      });
    }

    Navigator.pop(context);
    checkFavoritedStatus(); // Update favorited status
  }

  Future<void> favMovieDetails() async {
    final favSnapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .where('userId', isEqualTo: user?.uid)
        .get();

    if (favSnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('favorite').add({
        'userId': user?.uid,
        'movieId': [widget.movieId],
      });
    } else {
      final favId = favSnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('favorite')
          .doc(favId)
          .update({
        'movieId': FieldValue.arrayUnion([widget.movieId]),
      });
    }
  }

  void checkFavoritedStatus() async {
    final favSnapshot = await FirebaseFirestore.instance
        .collection('favorite')
        .where('userId', isEqualTo: user?.uid)
        .where('movieId', arrayContains: widget.movieId)
        .get();

    setState(() {
      isFavorited = favSnapshot.docs.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.network(
              '${Constants.imagePath}${widget.movie.backdropPath}',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        InkWell(
                          onTap: addFavMovie,
                          child: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${Constants.imagePath}${widget.movie.posterPath}',
                              height: 250,
                              width: 180,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 50, top: 30),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MovieButtons(
                    favMovie: addFavMovie,
                    isFavorited: isFavorited,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.movie.id.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.movie.overview ?? 'No overview available.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<Movie>>(
                    future: recommendedMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return RecommendWidget(
                          snapshot: snapshot,
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
