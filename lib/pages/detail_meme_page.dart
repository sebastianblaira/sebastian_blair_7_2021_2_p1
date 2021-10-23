import 'package:flutter/material.dart';
import 'package:memes_app/models/meme_model.dart';

class DetailsMemePage extends StatelessWidget {
  final Meme meme;
  const DetailsMemePage({
    Key? key,
    required this.meme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del meme'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: NetworkImage(meme.submissionUrl),
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
