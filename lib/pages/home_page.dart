import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/cubit/cubit/todo_cubit.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/ui/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: openCreateModal,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state.list.isEmpty) return emptyList;
          return listView(state.list);
        },
      ),
    );
  }

  Widget get emptyList {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/empty.json'),
          Text('Empty List', style: TextStyle(color: AppTheme.primaryColor)),
        ],
      ),
    );
  }

  Widget listView(List<TodoModel> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, index) {
        return itemCard(list[index]);
      },
    );
  }

  Widget itemCard(TodoModel todo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          title: Text(todo.title),
          subtitle: Text(todo.description ?? ''),
          leading: Checkbox(
            value: todo.isChecked,
            onChanged: (value) => context.read<TodoCubit>().toggle(todo.id),
          ),
          trailing: IconButton(
            onPressed: () => openConfirmDelete(todo),
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }

  void openCreateModal() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 240.0,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 40.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TodoCubit>().add(
                          title: titleController.text,
                          description: descriptionController.text,
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void openConfirmDelete(TodoModel todo) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<TodoCubit>().remove(todo.id);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
