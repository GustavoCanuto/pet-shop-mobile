import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const MenuScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('PetCare - Menu'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _botao(
              label: "Ver Meus Pets",
              icon: Icons.pets,
              onTap: () => Navigator.pushNamed(context, '/pets', arguments: userData),
            ),
            const SizedBox(height: 20),
            _botao(
              label: "Cadastrar Pet",
              icon: Icons.add_circle_outline,
              onTap: () => Navigator.pushNamed(
                context,
                '/add_pet',
                arguments: userData, // <-- passa os dados do usuário
              ),
            ),
            const SizedBox(height: 20),
            _botao(
              label: "Cadastrar Consulta",
              icon: Icons.assignment_add,
              onTap: () => Navigator.pushNamed(context, '/add_consulta'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botao({required String label, required IconData icon, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
