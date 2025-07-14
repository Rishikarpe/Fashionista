import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; 
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Supabase.initialize(
       url: 'https://odpcqpdbjuowxxlznlaf.supabase.co', // Replace with your Supabase Project URL
       anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9kcGNxcGRianVvd3h4bHpubGFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI0NzIwMDUsImV4cCI6MjA2ODA0ODAwNX0.21aJ5ZQPXz6I4-l6eY1vyXDXtng3v-RI0k9FSXAorAI', // Replace with your Supabase Anon Public Key
     );
     runApp(MyApp());
   }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion Wardrobe App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.session != null) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}