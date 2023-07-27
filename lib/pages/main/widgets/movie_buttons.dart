import 'package:flutter/material.dart';

class MovieButtons extends StatelessWidget {
  const MovieButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          MovieButton(iconName: Icons.add,),
          MovieButton(iconName: Icons.favorite_border,),
          MovieButton(iconName: Icons.download,),
          MovieButton(iconName: Icons.share,),
        ],
      ),
    );
  }
}

class MovieButton extends StatelessWidget {
  final IconData iconName;
  const MovieButton({
    super.key,
    required this.iconName,
  });

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
      child: Icon(
        iconName,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
