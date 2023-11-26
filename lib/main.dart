import 'dart:async';
import 'package:appmessaggi/pages/error_page.dart';
import 'package:appmessaggi/pages/loading_page.dart';
import 'package:appmessaggi/class/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/users_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(new MaterialApp(
    title: "Send Message App",
    initialRoute: '/loading',
    routes: {
      '/': (context) => SendSms(),
      '/showUsers': (context) => UsersList(),
      '/loading': (context) => LoadingPage(),
      '/error': (context) => ErrorPage(),
    },
  ));
}

class SendSms extends StatefulWidget {
  @override
  _SendSmsState createState() => new _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  static const platform = const MethodChannel('sendSms');
  final messageTextFieldController = TextEditingController();
  List<User> users = [];
  String message = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageTextFieldController.dispose();
    super.dispose();
  }

  Future sendSms(User u) async {
    String number = "${u.prefix}${u.phoneNumber}";
    print("SendSMS to ${u.name} ${u.surname} at number $number");
    message = "${messageTextFieldController.text}";
    message = message.replaceAll("COGNOME", u.surname);
    message = message.replaceAll("NOME", u.name);
    message = message.replaceAll("LINK", u.link);

    print(message);
    try {
      final String result = await platform.invokeMethod(
          'send', <String, dynamic>{
        "phone": number,
        "msg": message
      }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      Navigator.pushReplacementNamed(context, '/error',
          arguments: e.toString());
    }
  }

  showConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget finishButton = TextButton(
      child: Text("Finito"),
      style: TextButton.styleFrom(
          backgroundColor: Colors.green, primary: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("COnferma ricezione")),
      content: Text("Operazione Completata"),
      actions: [
        finishButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annulla"),
      style: TextButton.styleFrom(
          backgroundColor: Colors.redAccent, primary: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Continua"),
      onPressed: () async {
        try {
          for (User user in users) {
            await Future.delayed(
                Duration(milliseconds: dotenv.env['DELAY'] as int));
            sendSms(user);
          }
          Navigator.of(context).pop();
          showConfirmDialog(context);
        } catch (e) {
          Navigator.pushReplacementNamed(context, '/error',
              arguments: e.toString());
        }
      },
    );

    Widget testButton = TextButton(
      child: Text("Ricevi Anteprima"),
      style: TextButton.styleFrom(
          backgroundColor: Colors.green, primary: Colors.white),
      onPressed: () {
        sendSms(User(
            name: "Stefano",
            surname: "Parisi",
            phoneNumber: "3498303315",
            prefix: "39",
            link: "www.trentinoshop.com"));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("Conferma invio")),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              "Sei sicuro di voler inviare questo messaggio a ${users.length} utenti?"),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Text(
            "Anteprima messaggio:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text("${messageTextFieldController.text}"
              .replaceAll("COGNOME", "Parisi")
              .replaceAll("NOME", "Stefano")
              .replaceAll("LINK", "www.trentinoshop.com")),
        ],
      ),
      actions: [
        testButton,
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    users = ModalRoute.of(context)!.settings.arguments as List<User>;

    return new Material(
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Numero utenti ${users.length}",
                style: TextStyle(fontSize: 30, letterSpacing: 2),
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/showUsers',
                        arguments: users);
                  },
                  icon: Icon(Icons.list_outlined),
                  label: Text("Visualizza")),
              SizedBox(
                height: 40,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: TextField(
                  controller: messageTextFieldController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Messaggio'),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 100,
                child: TextButton(
                  onPressed: () => {showAlertDialog(context)},
                  child: const Text(
                    "Invia",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue, primary: Colors.white),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
