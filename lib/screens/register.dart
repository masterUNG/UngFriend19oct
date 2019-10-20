import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungfriend19oct/screens/my_service.dart';
import 'package:ungfriend19oct/screens/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Explicit
  String nameString, emailString, passwordString;
  final formKey = GlobalKey<FormState>();

  // Method
  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.adb,
          size: 36.0,
          color: Colors.purple,
        ),
        labelText: 'Display Name :',
        helperText: 'Type Your Name in Blank',
        hintText: 'English Only',
      ),
      onSaved: (String value) {
        nameString = value.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.green,
        ),
        labelText: 'Email :',
        helperText: 'Type Your Email in Blank',
        hintText: 'you@email.com',
      ),
      onSaved: (String value) {
        emailString = value.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.brown,
        ),
        labelText: 'Password :',
        helperText: 'Type Your Password in Blank',
        hintText: 'More 6 Charactor',
      ),
      onSaved: (String value) {
        passwordString = value.trim();
      },
    );
  }

  Widget registerButton() {
    return IconButton(
      tooltip: 'Upload to Server',
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        formKey.currentState.save();
        print(
            'name = $nameString, email = $emailString, password = $passwordString');
        registerThread();
      },
    );
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Register Success');
      setUpDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');
      myAlert(title, message);
    });
  }

  Future<void> setUpDisplayName() async {

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((response){
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nameString;
      response.updateProfile(userUpdateInfo);

      MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context)=>MyService());
      Navigator.of(context).pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route)=>false);


    });

  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        backgroundColor: MyStyle().textColor,
        title: Text('Register'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            nameText(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }
}
