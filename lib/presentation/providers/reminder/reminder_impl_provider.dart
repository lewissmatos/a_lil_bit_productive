import 'package:a_lil_bit_productive/domain/repository/reminder_repository.dart';
import 'package:a_lil_bit_productive/infrastructure/datasources_impl/reminder_datasource_impl.dart';
import 'package:a_lil_bit_productive/infrastructure/repository_impl/reminder_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reminderRepositoryImplProvider = Provider<ReminderRepository>((ref) =>
    ReminderRepositoryImpl(reminderDataSource: ReminderDataSourceImpl()));
