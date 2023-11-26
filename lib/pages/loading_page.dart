import 'dart:convert';
import 'package:appmessaggi/class/setting.dart';
import 'package:appmessaggi/class/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future loadNumbers() async {
    final response = await get(Uri.parse(dotenv.env['URL_CLIENTS'] as String));
    if (response.statusCode == 200) {
      parseUsers(response.body);
    } else {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/error',
          arguments: "Error retrieving users");
    }
  }

  Future loadSettings() async {
    final response = await get(Uri.parse(dotenv.env['URL_SETTINGS'] as String));
    if (response.statusCode == 200) {
      parseSettings(response.body);
    } else {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/error',
          arguments: "Error retrieving settings");
    }
  }

  void parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<User> users = parsed.map<User>((json) => User.fromJson(json)).toList();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/', arguments: users);
  }

  void parseSettings(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Setting> settings =
        parsed.map<Setting>((json) => Setting.fromJson(json)).toList();
    dotenv.env['DELAY'] = settings[0].value;
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
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
