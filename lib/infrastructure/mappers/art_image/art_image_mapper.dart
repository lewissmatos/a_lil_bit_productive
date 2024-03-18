import 'package:a_lil_bit_productive/helpers/color_helper.dart';
import 'package:a_lil_bit_productive/infrastructure/models/pexels_api/pexels_photos_response_model.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';

class ArtImageMapper {
  static ArtImage pexelsImageResponsePhotoToArtImage(PexelPhoto pexelPhoto) {
    return ArtImage(
      id: pexelPhoto.id,
      width: pexelPhoto.width,
      height: pexelPhoto.height,
      ogUrl: pexelPhoto.src.original,
      photographer: pexelPhoto.photographer,
      avgColor:
          ColorHelper.getColorFromHex(pexelPhoto.avgColor) ?? Colors.black,
      mediaUrl: pexelPhoto.src.portrait,
      alt: pexelPhoto.url,
    );
  }
}
