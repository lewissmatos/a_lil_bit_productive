import 'package:a_lil_bit_productive/domain/repository/short_story_repository.dart';
import 'package:a_lil_bit_productive/infrastructure/datasources_impl/short_story_datasource_impl.dart';
import 'package:a_lil_bit_productive/infrastructure/repository_impl/short_story_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shortStoryRepositoryImplProvider = Provider<ShortStoryRepository>((ref) =>
    ShortStoryRepositoryImpl(shortStoryDataSource: ShortStoryDataSourceImpl()));
