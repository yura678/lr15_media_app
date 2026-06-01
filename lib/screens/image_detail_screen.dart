import 'dart:io';

import 'package:flutter/material.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imagePath;

  const ImageDetailScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: InteractiveViewer(
            child: Image.file(File(imagePath)),
          ),
        ),
      ),
    );
  }
}
