import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streamlt/api/api.dart';
import 'package:streamlt/models/movie.dart';
import 'package:streamlt/pages/main/widgets/big_movie_card.dart';
import 'package:streamlt/pages/main/widgets/customnavbar.dart';
import 'package:streamlt/pages/main/widgets/movie_card.dart';
import 'package:streamlt/pages/main/widgets/search_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> nowPlayingMovies;
  final user = FirebaseAuth.instance.currentUser;
  final userData = FirebaseFirestore.instance.collection('users').get();
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> topRatedMovies;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nowPlayingMovies = Api().getMovies('movie/now_playing');
    upcomingMovies = Api().getMovies('movie/upcoming');
    popularMovies = Api().getMovies('movie/popular');
    topRatedMovies = Api().getMovies('movie/top_rated');
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

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
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "what to watch?",
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: IconButton(
                        onPressed: _signOut,
                        icon: const Icon(Icons.account_circle),
                        iconSize: 50,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF292B37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white54,
                      size: 30,
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(left: 5),
                      child: TextFormField(
                        controller: searchController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onFieldSubmitted: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchCard(
                                query: value,
                              ),
                            ),
                          );
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Movie>>(
                future: nowPlayingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return BigMovieCard(
                      snapshot: snapshot,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Movie>>(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return MovieCard(
                      title: 'Popular Movies',
                      snapshot: snapshot,
                      type: 'popular',
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Movie>>(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return MovieCard(
                      title: 'Top Rated Movies',
                      snapshot: snapshot,
                      type: 'top_rated',
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Movie>>(
                future: upcomingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return MovieCard(
                      title: 'Upcoming Movies',
                      snapshot: snapshot,
                      type: 'upcoming',
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
