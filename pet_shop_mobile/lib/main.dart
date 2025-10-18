import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/pets_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/pets':
            final userData = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_) => PetsScreen(userData: userData));
          default:
            return null;
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo ao PetCare')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
