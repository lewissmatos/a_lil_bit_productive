import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesFilterProvider =
    StateProvider<ExpensesFilter>((ref) => ExpensesFilter());
