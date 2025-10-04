import 'package:auth_app/Components/my_textfield.dart';
import 'package:auth_app/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  // wait for authentication

  // UI for authentication
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData?.scaffoldBackgroundColor,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight / 1.5, 
              width: constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.9,
              decoration: BoxDecoration(
                color: themeProvider.themeData?.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: themeProvider.themeData?.primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    MyTextfield(
                      label: "Email",
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.email, color: themeProvider.themeData?.iconTheme.color,),
                    ),
                    
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
