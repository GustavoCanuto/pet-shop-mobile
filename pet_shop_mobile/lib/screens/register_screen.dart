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

      if (result['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Usuário criado com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Erro ao criar usuário')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar com o servidor: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _sobrenomeController,
                decoration: const InputDecoration(labelText: 'Sobrenome'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                child: const Text('Criar Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
