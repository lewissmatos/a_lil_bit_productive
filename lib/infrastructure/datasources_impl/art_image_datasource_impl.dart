import 'package:a_lil_bit_productive/config/constants/environment.dart';
import 'package:a_lil_bit_productive/domain/datasources/art_image_datasource.dart';
import 'package:a_lil_bit_productive/infrastructure/mappers/art_image/art_image_mapper.dart';
import 'package:a_lil_bit_productive/infrastructure/models/pexels_api/pexels_photos_response_model.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/entities.dart';

class ArtImageDataSourceImpl extends ArtImageDataSource {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.pexels.com/v1', headers: {
    'Authorization':
        'WzBLmgVT77Mygu5LfXWcRaB7tbppXiHBCgTVpHATRnEi9hMKGSsN8gEr', //Environment.pexelsApiKey
  }));

  @override
  Future<List<ArtImage>> getArtImages({
    int? page = 1,
    int? perPage = 15,
  }) async {
    page ??= 1;
    perPage ??= 15;

    try {
      final response = await dio.get('/curated', queryParameters: {
        'page': page,
        'per_page': perPage,
      });

      final imagesMappedResponse =
          PexelsPhotosResponseModel.fromJson(response.data);
      final List<ArtImage> images = imagesMappedResponse.photos
          .map((e) => ArtImageMapper.pexelsImageResponsePhotoToArtImage(e))
          .toList();

      return images;
    } on DioException catch (_) {
      return [];
    }
  }

  @override
  Future<ArtImage?> getArtImage({required String id}) async {
    try {
      final response = await dio.get('photos/$id');
      final pexelsResponse = PexelPhoto.fromJson(response.data);

      return ArtImageMapper.pexelsImageResponsePhotoToArtImage(pexelsResponse);
    } on DioException catch (_) {
      return null;
    }
  }
}
