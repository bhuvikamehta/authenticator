import 'package:auth_app/Theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


// Stateful with the data of accounts logged in  .. 
// lsit of accounts (mutable)
// model will be inside the user 
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeData?.scaffoldBackgroundColor,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(
                Icons.exit_to_app,
                size: 25,
              ),
            ),
            onTap: () async {
                try {
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  // firebase sign out
                  await FirebaseAuth.instance.signOut();
                  // google sign out -> next time ask for account again 
                  await googleSignIn.disconnect();

                }
                catch (e) {
                  // shows the snack bar for them error message
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    SnackBar(
                    content: Text(
                      e.toString()
                    ),
                  )
                );
              }
            }
      

          )
        ],
      ),
      body: Center(
        child: Text(
          "Hello Biatch from Home Screen !!!!"
        ),
      ),
    );
  }
}