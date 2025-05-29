import 'package:flutter/material.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({required this.isFavorite, super.key});

  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Icon(isFavorite ? Icons.favorite : Icons.favorite_border_outlined);
  }
}
