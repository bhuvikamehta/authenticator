import 'package:auth_app/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
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
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeProvider.themeData?.appBarTheme.foregroundColor,
      ),
      body: Center(
        child: Text(
          "Hello Biatch from Home Screen !!!!"
        ),
      ),
    );
  }
}