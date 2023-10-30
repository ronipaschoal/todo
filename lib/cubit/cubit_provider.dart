import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo/cubit/cubit/todo_cubit.dart';
import 'package:todo/services/db_service.dart';

class CubitProviders {
  static final List<BlocProvider> instancies = [
    BlocProvider<TodoCubit>(
      create: (context) => TodoCubit(
        dbService: GetIt.instance<DbService>(),
      ),
    ),
  ];
}
