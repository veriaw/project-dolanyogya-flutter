import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project_tpm/models/place_hivi.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/screens/Login.dart';
import 'package:project_tpm/screens/MainMenu.dart';
import 'package:project_tpm/services/bookmark_service.dart';
import 'package:project_tpm/utils/rsa_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> darkModeNotifier = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');
  Hive.registerAdapter(HiviModelAdapter());
  await BookmarkService.openBox();

  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('privateKey')) {
    await RSAHelper.generateAndStoreKeys();
  }

  // Cek session login
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  // Cek dark mode
  final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
  darkModeNotifier.value = isDarkMode;

  runApp(MainApp(isLoggedIn: isLoggedIn));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  const MainApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: Color(0xFF4DB7B7),
              secondary: Color(0xFFFFAD1F),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: Color(0xFF4DB7B7),
              secondary: Color(0xFFFFAD1F),
            ),
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: isLoggedIn ? MainMenu() : LoginPage(),
        );
      },
    );
  }
}
