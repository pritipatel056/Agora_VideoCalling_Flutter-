import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/login/login_screen.dart';
import 'presentation/users/users_screen.dart';
import 'presentation/video/video_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users_cache');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Meet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/users': (_) => const UsersScreen(),
        '/video': (_) => const VideoScreen(),
      },
    );
  }
}