import 'package:flutter/material.dart';

//Screen's top image
class TopImage extends StatelessWidget {
  const TopImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(50.0),
        ),
      ),
    );
  }
}