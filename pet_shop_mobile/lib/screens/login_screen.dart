import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final result = await ApiService.login(_emailController.text, _senhaController.text);
      setState(() => _loading = false);

      if (result['status'] == true) {

        final dados = result['data'];

        // 🔥 1. VERIFICAR PERMISSÃO
        if (dados['permissao'] != 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Você não tem permissão para acessar o aplicativo."),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // 🔹 2. SALVAR EMAIL E SENHA
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", _emailController.text);
        await prefs.setString("senha", _senhaController.text);

        // 🔹 3. ENTRAR NO APP
        Navigator.pushReplacementNamed(context, '/menu', arguments: dados);

      } else {
        // 🔥 erro de login (senha incorreta, usuário não existe etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Erro desconhecido')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar: ${e.toString()}')),
      );
    }
  }



  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.tealAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.pets, color: Colors.pinkAccent, size: 48),
              const SizedBox(height: 12),
              const Text("Login - Dono de Pet",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Entre na sua conta para cuidar melhor do seu pet 🐾",
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 24),
              TextField(controller: _emailController, decoration: _inputDecoration("Email", Icons.email)),
              const SizedBox(height: 16),
              TextField(controller: _senhaController, decoration: _inputDecoration("Senha", Icons.lock), obscureText: true),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator(color: Colors.tealAccent)
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _login,
                  child: const Text("Entrar", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Não tem uma conta?", style: TextStyle(color: Colors.white70)),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("Criar conta", style: TextStyle(color: Colors.tealAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
