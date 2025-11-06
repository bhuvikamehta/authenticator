import 'package:auth_app/Pages/home_page.dart';
import 'package:auth_app/Theme/theme_provider.dart';
import 'package:auth_app/Models/totp_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_locker/flutter_locker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TotpCardAdapter());

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check biometric availability
  final bool supportsBiometric = await FlutterLocker.supportsBiometricAuthentication();
  final bool canAuthenticate = await FlutterLocker.canAuthenticate();

  if (supportsBiometric && canAuthenticate) {
    try {
      // Optional: Do an initial authentication to unlock secure data
      await FlutterLocker.retrieve(RetrieveSecretRequest(
        key: 'biometric_auth',
        androidPrompt: AndroidPrompt(
          title: 'Authenticate',
          cancelLabel: 'Cancel',
        ),
        iOsPrompt: IOsPrompt(touchIdText: 'Authenticate to unlock the app'),
      ));
    } on LockerException catch (e) {
      debugPrint('LockerException: ${e.reason}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  } else {
    debugPrint('Biometric authentication not available or not set up.');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // remove debug banner
      title: 'Auth App',
      theme: themeProvider.themeData,
      home: const HomePage(),
      // home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), 
      // builder: (context, snapshot) {
      //   if (snapshot.connectionState == ConnectionState.waiting){
      //     return const Center(child: CircularProgressIndicator());
      //   }
      //   if (snapshot.hasError){
      //     return const Center(child: Text("Something Went Wrong !!!" ));
      //   }
      //   if(snapshot.hasData && snapshot.data != null){
      //     return const HomePage();
      //   }
      //   return const AuthPage();
      // },)
    );
  }
}
