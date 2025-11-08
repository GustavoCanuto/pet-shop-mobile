import 'package:flutter/material.dart';
import 'package:pet_shop_mobile/screens/consulta_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/pets_screen.dart';
import 'screens/home_menu_screen.dart';
import 'screens/add_pet_screen.dart'; //
import 'screens/add_consulta_screen.dart'; //
import 'screens/add_pet_screen.dart';
import 'screens/add_consulta_screen.dart';
import 'screens/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Função de tela de erro, agora dentro da classe
  MaterialPageRoute _erroTela() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(
            "Erro: dados do usuário não encontrados.",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

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
          final args = settings.arguments;
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterScreen());

            case '/menu':
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(builder: (_) => MenuScreen(userData: args));
              }
              return _erroTela();

            case '/home':
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(builder: (_) => HomeMenuScreen(userData: args));
              }
              return _erroTela();

            case '/pets':
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(builder: (_) => PetsScreen(userData: args));
              }
              return _erroTela();

            case '/add_pet':
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(builder: (_) => AddPetScreen(userData: args));
              }
              return _erroTela();

            case '/add_consulta':
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(builder: (_) => AddConsultaScreen(userData: args));
              }
              return _erroTela();

            case '/consultas':
              if (args is Map<String, dynamic>) {
                return MaterialPageRoute(builder: (_) => ConsultasScreen(userData: args));
              }
              return _erroTela();

            default:
              return _erroTela();
          }
        },

    );
  }
}
