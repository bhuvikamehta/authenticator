import 'package:animated_toggle_switch/animated_toggle_switch.dart';
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: SizedBox(
              width: 60,
              height: 30,
              child: AnimatedToggleSwitch<bool>.dual(
                current: themeProvider.isDark,
                first: false,
                second: true,
                spacing: 0,
                animationDuration: const Duration(milliseconds: 1500),
                animationCurve: Curves.bounceInOut,
                borderWidth: 2.0,
                height: 40,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                iconBuilder: (value) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 5000),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey(value),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 10,
                          blurRadius: 10,

                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: value 
                      ? const Icon(
                          Icons.nightlight_round,
                          color: Colors.yellowAccent,
                          size: 22,
                        )
                      : const Icon(
                          Icons.wb_sunny,
                          color: Colors.amber,
                          size: 22,
                        ),
                  ),
                ),
                textBuilder: (value) => const SizedBox.shrink(),
              ),
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
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
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: themeProvider.themeData?.secondaryHeaderColor,
        child: Column(
          children: [
            DrawerHeader(child: Text("Hello User")),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Terms and Conditions"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.question_mark),
              title: Text("How it works ?"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Hello Biatch from Home Screen !!!!"
        ),
      ),
    );
  }
}