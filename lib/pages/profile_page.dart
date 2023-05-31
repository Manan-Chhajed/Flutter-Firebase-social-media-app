import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app_mitch/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            onChanged: (value) {
              newValue = value;
            }),
        actions: [
          // cancel
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          // save
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // update field
    if (newValue.trim().length > 0) {
      userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                // profile picture
                Icon(
                  Icons.person,
                  color: Colors.grey[900],
                  size: 80,
                ),

                const SizedBox(height: 15),
                // user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 50),
                // user name and stuff
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "My details",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),

                MyTextBox(
                  text: userData["username"],
                  sectionName: "Username",
                  onPressed: () => editField("username"),
                ),

                MyTextBox(
                  text: userData["bio"],
                  sectionName: "Bio",
                  onPressed: () => editField("bio"),
                ),

                const SizedBox(height: 50),
                // user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "My posts",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
