import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'core/database/app_database.dart';
import 'data/repositories/login_repository.dart';
import 'data/repositories/task_repository.dart';
import 'presentation/screens/login/login_view.dart';
import 'presentation/screens/home/home_view.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final database = await AppDatabase.instance.database;
  
  runApp(
    MultiProvider(
      providers: [
        Provider<LoginRepository>(
          create: (_) => LoginRepository(FlutterSecureStorage()),
        ),
        Provider<TaskRepository>(
          create: (_) => TaskRepository(database),
        ),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mundo Wap Task App',
      theme: AppTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: Provider.of<LoginRepository>(context, listen: false).isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const HomeView() : const LoginView();
        },
      ),
    );
  }
}
