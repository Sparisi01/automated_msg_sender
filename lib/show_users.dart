import 'package:appmessaggi/user.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {



  @override
  Widget build(BuildContext context) {

    List<User> users = ModalRoute.of(context)!.settings.arguments as List<User>;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista contatti"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(User u in users)
              Container(
                width: double.infinity,
                height: 80,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Text('${u.name} ${u.surname}', style: TextStyle(fontSize: 20),),
                          SizedBox(height: 10,),
                          Text('+${u.prefix} ${u.phoneNumber}'),
                          SizedBox(height: 10,),
                        ],
                      )
                    )
                )
              )
          ],
        ),
      )
    );
  }
}


