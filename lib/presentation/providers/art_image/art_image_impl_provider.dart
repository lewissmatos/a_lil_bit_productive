import 'package:a_lil_bit_productive/infrastructure/datasources_impl/art_image_datasource_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repository/art_image_repository.dart';
import '../../../infrastructure/repository_impl/art_image_repository_impl.dart';

final artImageRepositoryImplProvider = Provider<ArtImageRepository>((ref) =>
    ArtImageRepositoryImpl(artImageDataSource: ArtImageDataSourceImpl()));
