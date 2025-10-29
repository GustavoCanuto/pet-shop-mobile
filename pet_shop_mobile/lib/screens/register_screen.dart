import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final data = {
      "nome": _nomeController.text,
      "sobrenome": _sobrenomeController.text,
      "email": _emailController.text,
      "senha": _senhaController.text,
      "permissao": 1
    };

    try {
      final result = await ApiService.registerUser(data);
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Usuário criado com sucesso!')),
      );
      if (result['status'] == true) {
        Navigator.pushReplacementNamed(context, '/login');
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.favorite, color: Colors.pinkAccent, size: 48),
                const SizedBox(height: 12),
                const Text("Criar Conta - Dono de Pet",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Junte-se à nossa comunidade de amantes de pets! 🐾",
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                TextFormField(controller: _nomeController, decoration: _inputDecoration("Nome", Icons.person)),
                const SizedBox(height: 16),
                TextFormField(controller: _sobrenomeController, decoration: _inputDecoration("Sobrenome", Icons.person_outline)),
                const SizedBox(height: 16),
                TextFormField(controller: _emailController, decoration: _inputDecoration("Email", Icons.email)),
                const SizedBox(height: 16),
                TextFormField(controller: _senhaController, decoration: _inputDecoration("Senha", Icons.lock), obscureText: true),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmarSenhaController,
                  decoration: _inputDecoration("Confirmar Senha", Icons.lock_outline),
                  obscureText: true,
                  validator: (v) => v != _senhaController.text ? 'As senhas não coincidem' : null,
                ),
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
                    onPressed: _register,
                    child: const Text("Criar conta como dono de pet", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
