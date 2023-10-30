import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/services/db_service.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final DbService dbService;

  TodoCubit({required this.dbService}) : super(TodoState());

  void load() {
    final list = dbService
        .values()
        .map(
          (item) => TodoModel.fromJson(item),
        )
        .toList();

    emit(state.copyWith(list: list));
  }

  void add({
    required String title,
    String? description,
  }) {
    final newTodo = TodoModel(
      id: DateTime.now().toString(),
      title: title,
      description: description,
    );

    dbService.add(newTodo.toJson());
    emit(state.copyWith(list: [...state.list, newTodo]));
  }

  void remove(String id) {
    final index = state.list.indexWhere((item) => item.id == id);
    state.list.removeAt(index);
    dbService.delete(index);
    emit(state.copyWith(list: state.list));
  }

  void toggle(String id) {
    final index = state.list.indexWhere((item) => item.id == id);
    final item = state.list[index];
    item.isChecked = !item.isChecked;
    state.list[index] = item;
    dbService.putAt(index, item.toJson());
    emit(state.copyWith(list: state.list));
  }
}
