import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'pages/error_page.dart';
import 'pages/loading_page.dart';
import 'pages/users_list_page.dart';
import 'pages/home_page.dart';
import 'pages/sending_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(new MaterialApp(
    title: "Send Message App",
    initialRoute: '/loading',
    routes: {
      '/': (context) => HomePage(),
      '/showUsers': (context) => UsersListPage(),
      '/loading': (context) => LoadingPage(),
      '/error': (context) => ErrorPage(),
      '/sending': (context) => SendingPage(),
    },
  ));
}
