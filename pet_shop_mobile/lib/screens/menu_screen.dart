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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _menuButton(
              label: "Ver Meus Pets",
              icon: Icons.pets,
              onTap: () => Navigator.pushNamed(context, '/pets', arguments: userData),
            ),
            const SizedBox(height: 20),
            _menuButton(
              label: "Cadastrar Pet",
              icon: Icons.add_circle_outline,
              onTap: () => Navigator.pushNamed(context, '/add_pet', arguments: userData),
            ),
            const SizedBox(height: 20),
            _menuButton(
              label: "Cadastrar Consulta",
              icon: Icons.assignment_add,
              onTap: () => Navigator.pushNamed(context, '/add_consulta', arguments: userData),
            ),
            const SizedBox(height: 20),
            _menuButton(
              label: "Ver Minhas Consultas",
              icon: Icons.calendar_today,
              onTap: () => Navigator.pushNamed(context, '/consultas', arguments: userData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,  // Botão ocupa toda a largura
      height: 60,              // Altura fixa para todos os botões
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
