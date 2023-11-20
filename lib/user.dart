import 'package:flutter/material.dart';

class User {
  String name;
  String surname;
  String phoneNumber;
  String prefix;
  String link;

  User(
      {required this.name,
      required this.surname,
      required this.phoneNumber,
      required this.prefix,
      required this.link});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['Nome'],
      surname: json['Cognome'],
      prefix: json['Prefisso'],
      phoneNumber: json['Numero'],
      link: json['Link'],
    );
  }
}
