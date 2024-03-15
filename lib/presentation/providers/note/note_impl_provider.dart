import 'package:a_lil_bit_productive/domain/repository/note_repository.dart';
import 'package:a_lil_bit_productive/infrastructure/datasources_impl/note_datasource_impl.dart';
import 'package:a_lil_bit_productive/infrastructure/repository_impl/note_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteRepositoryImplProvider = Provider<NoteRepository>(
    (ref) => NoteRepositoryImpl(noteDatasource: NoteDatasourceImpl()));
