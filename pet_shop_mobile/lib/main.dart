import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/pets_screen.dart';
import 'screens/home_menu_screen.dart';
import 'screens/add_pet_screen.dart'; // você vai criar depois
import 'screens/add_consulta_screen.dart'; // você vai criar depois
import 'screens/add_pet_screen.dart';
import 'screens/add_consulta_screen.dart';
import 'screens/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/menu':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(builder: (_) => HomeMenuScreen(userData: args));
            } else {
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text(
                      "Erro: dados do usuário não encontrados.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }
          case '/pets':
            final userData = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_) => PetsScreen(userData: userData));
          case '/add_pet':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              return MaterialPageRoute(builder: (_) => AddPetScreen(userData: args));
            } else {
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text(
                      "Erro: dados do usuário não encontrados.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }
          case '/add_consulta':
            return MaterialPageRoute(builder: (_) => const AddConsultaScreen());
          case '/menu':
            final userData = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (_) => MenuScreen(userData: userData));
          default:
            return null;
        }
      },
    );
  }
}
