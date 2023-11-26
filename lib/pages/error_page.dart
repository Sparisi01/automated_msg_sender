import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {

    String error = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: SafeArea(
          child: Text(error)
      )
    );
  }
}
