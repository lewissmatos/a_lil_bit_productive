import '../entities/entities.dart';

abstract class ArtImageDataSource {
  Future<ArtImage?> getArtImage({required String id});
  Future<List<ArtImage?>> getArtImages({int? page = 1, int? perPage = 15});
}
