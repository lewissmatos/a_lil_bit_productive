import 'package:a_lil_bit_productive/domain/repository/expense_repository.dart';
import 'package:a_lil_bit_productive/infrastructure/datasources_impl/expense_datasource_impl.dart';
import 'package:a_lil_bit_productive/infrastructure/repository_impl/expense_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseRepositoryImplProvider = Provider<ExpenseRepository>(
    (ref) => ExpenseRepositoryImpl(expenseDataSource: ExpenseDataSourceImpl()));
