import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auth_app/Components/auth_card.dart';
import 'package:auth_app/Models/account.dart';
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
    final theme = Theme.of(context);
    final elevatedButtonStyle = theme.elevatedButtonTheme.style;
    final buttonBackgroundColor = elevatedButtonStyle?.backgroundColor?.resolve({}) ?? theme.primaryColor;
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: themeProvider.themeData?.scaffoldBackgroundColor,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 0),
            decoration: BoxDecoration(
              color: buttonBackgroundColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 28),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 0),
              padding: const EdgeInsets.only(left: 20, right: 12, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: buttonBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
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
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                  const SizedBox(width: 12),
                  GestureDetector(
                    child: const Icon(
                      Icons.exit_to_app,
                      size: 25,
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
            ),
          ],
        ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            AuthCard(
              totpCard: TOTPCard(
                id: '1',
                accountName: 'Test your strength',
                issuer: 'Running Challenge',
                secret: 'JBSWY3DPEHPK3PXP', // Example secret
                digits: 6,
                period: 30,
                createdAt: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new account action
        },
        backgroundColor: themeProvider.themeData?.primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}