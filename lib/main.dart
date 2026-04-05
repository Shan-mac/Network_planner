import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'dashboard.dart'; 

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://lhkctdwhorodqfnnoahj.supabase.co',
    anonKey: 'sb_publishable_g7dUePT7s9iI4y6Dw78D2A_SIDEZZps',
  );

  runApp(const NetCalcApp());
}

final supabase = Supabase.instance.client;

class NetCalcApp extends StatelessWidget {
  const NetCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'NetCalc Toolkit',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent, 
              brightness: Brightness.light
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent, 
              brightness: Brightness.dark
            ),
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
            ),
          ),
          home: supabase.auth.currentSession == null 
              ? const LoginPage() 
              : const Dashboard(),
        );
      },
    );
  }
}