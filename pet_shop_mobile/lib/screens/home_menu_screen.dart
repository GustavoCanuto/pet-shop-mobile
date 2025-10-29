import 'package:flutter/material.dart';

class HomeMenuScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HomeMenuScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, ${userData['nome']} 👋"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            menuButton(context, "Cadastrar Pet", "/add_pet", args: userData),
            const SizedBox(height: 20),
            menuButton(context, "Cadastrar Consulta", "/add_consulta"),
            const SizedBox(height: 20),
            menuButton(context, "Ver Meus Pets", "/pets", args: userData),
          ],
        ),
      ),
    );
  }

  Widget menuButton(BuildContext context, String text, String route, {dynamic args}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: () => Navigator.pushNamed(context, route, arguments: args),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
