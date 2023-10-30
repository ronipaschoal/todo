import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/cubit/cubit_provider.dart';
import 'package:todo/routes.dart';
import 'package:todo/services/db_service.dart';
import 'package:todo/ui/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  GetIt.instance.registerSingletonAsync<DbService>(
    () async => DbService(
      box: await Hive.openBox('todo_list'),
    ),
  );

  await GetIt.instance.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: CubitProviders.instancies,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo List',
        theme: AppTheme.themeData,
        routes: Routes.routes,
        initialRoute: Routes.home,
      ),
    );
  }
}
