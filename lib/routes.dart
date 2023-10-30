import 'package:flutter/material.dart';
import 'package:todo/pages/home_page.dart';

sealed class Routes {
  static const home = '/home';

  static final routes = <String, WidgetBuilder>{
    home: (context) => const HomePage(),
  };
}
