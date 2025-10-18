import 'package:flutter/material.dart';
import '../services/api_service.dart';

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
        // login ok: passa os dados do usuário para a tela de pets
        Navigator.pushReplacementNamed(context, '/pets', arguments: result['data']);
      } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
