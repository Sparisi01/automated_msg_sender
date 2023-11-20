import 'dart:convert';

import 'package:appmessaggi/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  Future loadNumbers() async{
    final response = await get(Uri.parse('https://sheetdb.io/api/v1/mvt3euwmyiruw'));
    if (response.statusCode == 200) {
      print(response.body);
      parseUsers(response.body);
    } else {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/error', arguments: "Error retrieving data");
    }
  }

  void parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<User> users = parsed.map<User>((json) => User.fromJson(json)).toList();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/', arguments: users);
  }

  @override
  void initState() {
    super.initState();
    loadNumbers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        body: Center(
          child: SpinKitFadingCircle(
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );

  }
}
