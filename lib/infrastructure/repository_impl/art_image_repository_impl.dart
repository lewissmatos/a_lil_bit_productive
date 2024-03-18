import 'package:a_lil_bit_productive/domain/datasources/art_image_datasource.dart';
import 'package:a_lil_bit_productive/domain/repository/art_image_repository.dart';

import '../../domain/entities/entities.dart';

class ArtImageRepositoryImpl extends ArtImageRepository {
  ArtImageDataSource artImageDataSource;

  ArtImageRepositoryImpl({
    required this.artImageDataSource,
  });

  @override
  Future<ArtImage?> getArtImage({required String id}) async {
    return await artImageDataSource.getArtImage(id: id);
  }

  @override
  Future<List<ArtImage?>> getArtImages({
    int? page = 1,
    int? perPage = 15,
  }) async {
    return await artImageDataSource.getArtImages(
      page: page,
      perPage: perPage,
    );
  }
}
