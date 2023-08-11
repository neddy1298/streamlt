import 'package:flutter/material.dart';

class MovieButtons extends StatefulWidget {
  final Function() favMovie;
  final bool isFavorited;

  const MovieButtons(
      {Key? key, required this.favMovie, required this.isFavorited})
      : super(key: key);

  @override
  State<MovieButtons> createState() => _MovieButtonsState();
}

class _MovieButtonsState extends State<MovieButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MovieButton(
            iconName: Icons.add,
            onTap: () {
              // Perform action when "Add" button is tapped
            },
          ),
          MovieButton(
            iconName: widget.isFavorited
                ? Icons.favorite
                : Icons.favorite_border, // Use the isFavorited variable
            onTap: widget.favMovie,
          ),
          MovieButton(
            iconName: Icons.download,
            onTap: () {
              // Perform action when "Download" button is tapped
            },
          ),
          MovieButton(
            iconName: Icons.share,
            onTap: () {
              // Perform action when "Share" button is tapped
            },
          ),
        ],
      ),
    );
  }
}

class MovieButton extends StatelessWidget {
  final IconData iconName;
  final Function() onTap;

  const MovieButton({
    Key? key,
    required this.iconName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF292B37),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF292B37).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          iconName,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
