import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project02/authscreen.dart';
import 'package:project02/cartitem.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Map<String, dynamic>? userData; // Use a map to store user data

  void loading() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection("users").doc(uid).get();

      // Check if the document exists before extracting data
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loading();
  } void _incrementCounter() {
    CollectionReference df = FirebaseFirestore.instance.collection("users");
    df.add({
      'email': "Farhan Khan",
      'fullName': '28',
      'phoneNumber': '1234',
    });

    setState(() {
      _counter++;
    });
  }
  TextEditingController _updatedEmailController = TextEditingController();
  TextEditingController _updatedFullNameController = TextEditingController();
  TextEditingController _updatedPhoneNumberController = TextEditingController();

  void _update() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Show a dialog to get updated information from the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Information'),
            content: Column(
              children: [
                TextField(
                  controller: _updatedEmailController,
                  decoration: InputDecoration(labelText: 'Updated Email'),
                ),
                TextField(
                  controller: _updatedFullNameController,
                  decoration: InputDecoration(labelText: 'Updated Full Name'),
                ),
                TextField(
                  controller: _updatedPhoneNumberController,
                  decoration: InputDecoration(labelText: 'Updated Phone Number'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  // Perform the update with the input values
                  await FirebaseFirestore.instance.collection("users").doc(uid).update({
                    'email': _updatedEmailController.text,
                    'fullName': _updatedFullNameController.text,
                    'phoneNumber': _updatedPhoneNumberController.text,
                  });

                  // After updating, reload the user data
                  loading();

                  // Close the dialog
                  Navigator.pop(context);
                },
                child: Text('Update'),
              ),
            ],
          );
        },
      );
    }
  }
  void _deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Delete user account from Firebase Authentication
      await user.delete();

      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();

      // Navigate to the login screen after deletion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }


  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     // return IconButton(
        //     //   icon: const Icon(Icons.menu), // Add a leading icon for the drawer
        //     //   onPressed: () {
        //     //     Scaffold.of(context).openDrawer();
        //     //   },
        //     // );
        //   },
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),

      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: _logout,
      //     ),
      //   ],
      // ),
      // ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: Text(
                'Full Name: ${userData?["fullName"] ?? ""}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.greenAccent),
              ),
              // tileColor: Colors.greenAccent,
            ),

            ListTile(
              title: Text(
                'Email: ${userData?["email"] ?? ""}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.greenAccent),
              ),
              // tileColor: Colors.greenAccent,

            ),

            ListTile(
              title: Text(
                'Phone Number: ${userData?["phoneNumber"] ?? ""}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.greenAccent),
              ),
              // tileColor: Colors.greenAccent,
            ),

            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(onPressed: _logout, child: Text("Logout")),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(onPressed: _update, child: Text("Update")),

                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _deleteAccount,
                      child: Text("Delete Account"),
                    )
                  ],
                )
              ],
            )


          ],
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(110.0),
      //   child: FloatingActionButton(
      //     onPressed: _logout,
      //     tooltip: 'Increment',
      //     child: const Icon(Icons.logout),
      //   ),
      // ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(

                  "Abhishek Mishra",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("abhishekm977@gmail.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                MaterialPageRoute(builder: (context) => MyHomePage(title: ""));
              },
            ),
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Add to Cart List'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductItem(uid: '',)),
          );
        },
      ),
            // ),
            // ListTile(
            //   leading: const Icon(Icons.workspace_premium),
            //   title: const Text(' Go Premium '),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.video_label),
            //   title: const Text(' Saved Videos '),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.edit),
            //   title: const Text(' Edit Profile '),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.logout),
            //   title: const Text('LogOut'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            
          ],
        ),
      ),
    );
  }
}