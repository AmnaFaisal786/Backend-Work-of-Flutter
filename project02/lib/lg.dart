import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp03 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen Example',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  void UpdateUser(String uname,String pass,String fName,String age,String uid){
    CollectionReference cf = FirebaseFirestore.instance.collection("students");
    cf.doc(uid).set({
      "name":fName,
      "age":age,
      "email":uname
    });
  }
  void AddUser(String uname,String pass,String fName,String age) async{
    UserCredential UserInfo =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: uname, password: pass);
    CollectionReference cf = FirebaseFirestore.instance.collection("students");

    if(UserInfo.user!.uid !=null){

      print(UserInfo.user!.uid);
      cf.doc(UserInfo.user!.uid).set({
        "name":fName,
        "age":age,
        "email":uname
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _fullnameController,

                decoration: InputDecoration(
                  labelText: 'Name Here',
                  icon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _ageController,

                decoration: InputDecoration(
                  labelText: 'Age Here',
                  icon: Icon(Icons.numbers),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement your login logic here
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      String users = _fullnameController.text;
                      String age = _ageController.text;
                      AddUser(username, password, users, age);


                      // For now, let's print the entered credentials
                      print('Username: $username, Password: $password');
                    },
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement your login logic here
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      String users = _fullnameController.text;
                      String age = _ageController.text;
                      UpdateUser(username, password, users, age,"puqsf9TyzFXc0V9pLS10dLuUp5s1");


                      // For now, let's print the entered credentials
                      print('Username: $username, Password: $password');
                    },
                    child: Text('Update'),
                  )
                ],
              )


            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}