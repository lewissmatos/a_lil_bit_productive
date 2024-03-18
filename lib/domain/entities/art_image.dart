import 'package:flutter/material.dart';

class ArtImage {
  final int id;
  final int width;
  final int height;
  final String ogUrl;
  final String photographer;
  final Color? avgColor;
  final String mediaUrl;
  final String alt;

  ArtImage({
    required this.id,
    required this.width,
    required this.height,
    required this.ogUrl,
    required this.photographer,
    this.avgColor,
    required this.mediaUrl,
    required this.alt,
  });

  copyWith({
    int? id,
    int? width,
    int? height,
    String? ogUrl,
    String? photographer,
    Color? avgColor,
    String? mediaUrl,
    String? alt,
  }) =>
      ArtImage(
        id: id ?? this.id,
        width: width ?? this.width,
        height: height ?? this.height,
        ogUrl: ogUrl ?? this.ogUrl,
        photographer: photographer ?? this.photographer,
        avgColor: avgColor ?? this.avgColor,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        alt: alt ?? this.alt,
      );
}
