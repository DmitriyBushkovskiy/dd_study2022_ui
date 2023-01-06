import 'package:flutter/material.dart';

class ImageWithPath {
  String path;
  Image image;

  ImageWithPath({
    required this.path,
    required this.image,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageWithPath && other.path == path && other.image == image;
  }

  @override
  int get hashCode => path.hashCode ^ image.hashCode;
}