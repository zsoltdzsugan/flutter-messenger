import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:messenger/core/auth/provider.dart';
import 'package:messenger/core/theme/provider.dart';
import 'package:messenger/core/theme/theme.dart';
import 'package:messenger/view/home/home_page.dart';
import 'package:messenger/view/login/login_page.dart';
import 'package:messenger/view/register/register_page.dart';
import 'package:messenger/view/root_page.dart';
import 'package:messenger/view/welcome/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await windowManager.ensureInitialized();

  const minWindowSize = Size(700, 500);
  windowManager.setMinimumSize(minWindowSize);
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: minWindowSize,
    size: Size(1280, 720),
    center: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..getThemeMode()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, theme, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.currentTheme,
            home: RootPage(),
            routes: {
              WelcomePage.route: (context) => const WelcomePage(),
              RegisterPage.route: (context) => const RegisterPage(),
              LoginPage.route: (context) => const LoginPage(),
              HomePage.route: (context) => const HomePage(),
            },
          );
        },
      ),
    );
  }
}
