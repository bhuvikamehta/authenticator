import 'package:auth_app/Components/my_textfield.dart';
import 'package:auth_app/Theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSignUp = true; // Toggle between Sign Up and Sign In

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Sign in with Google and return a Firebase User on success, or null if cancelled.
  Future<User?> _signInWithGoogle() async {
    // Trigger the Google Authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user aborted the sign-in

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google [UserCredential]
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeData?.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: themeProvider.themeData?.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon/Avatar at the top
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? const Color(0xFFE8D5C4)
                        : const Color(0xFFFFE5D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 30,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: isDark 
                              ? const Color(0xFF9B6B9E)
                              : const Color(0xFFA67C9F),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 30,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: isDark 
                              ? const Color(0xFFE8D5C4)
                              : const Color(0xFFE8D5B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Title
                Text(
                  _isSignUp ? "Create Your Account" : "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeData?.textTheme.displayLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  _isSignUp 
                      ? "Join Authenticator to secure your digital life."
                      : "Sign in to continue to your account.",
                  style: TextStyle(
                    fontSize: 14,
                    color: themeProvider.themeData?.textTheme.bodyMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Email Address Field
                MyTextfield(
                  label: "Email Address",
                  hintText: "Enter your email",
                  textController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                
                // Password Field
                MyTextfield(
                  label: "Password",
                  hintText: "Enter your password",
                  textController: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                
                // Confirm Password Field (only for Sign Up)
                if (_isSignUp) ...[
                  MyTextfield(
                    label: "Confirm Password",
                    hintText: "Re-enter your password",
                    textController: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                if (!_isSignUp) const SizedBox(height: 24),
                
                // Sign Up / Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle sign up/sign in logic
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _isSignUp ? "Sign Up" : "Sign In",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Divider with text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Google Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Trigger Google Sign-In
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        // google_sign_in dependency 
                        final user = await _signInWithGoogle();
                        // notification fore thet user
                        if (user != null) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Signed in with Google')),
                          );
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Google sign in cancelled')),
                          );
                        }
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Google sign in failed: $e')),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://www.google.com/favicon.ico'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    label: Text(
                      "Continue with Google",
                      style: TextStyle(
                        color: themeProvider.themeData?.textTheme.bodyLarge?.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Toggle between Sign In and Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignUp 
                          ? "Already have an account? "
                          : "Don't have an account? ",
                      style: TextStyle(
                        color: themeProvider.themeData?.textTheme.bodyMedium?.color,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                        });
                      },
                      child: Text(
                        _isSignUp ? "Sign In" : "Sign Up",
                        style: const TextStyle(
                          color: Color(0xFF0EA5E9),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (_isSignUp)
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF0EA5E9),
                        size: 16,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
