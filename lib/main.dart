import 'package:auth_app/Pages/home_page.dart';
import 'package:auth_app/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(create: (context) => ThemeProvider(),
    child: App(),
    )
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
